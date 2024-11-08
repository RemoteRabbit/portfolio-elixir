defmodule PortfolioWeb.PageController do
  @moduledoc """
  The PageController module handles the routing and rendering of pages in the Portfolio web application.

  ## Functions

  - `home/2`: Renders the home page.
  - `blog/2`: Retrieves a list of blog posts and renders the blog page.
  - `show_posts/2`: Retrieves a specific blog post by its slug and renders the post page. If the post is not found, it renders a 404 page.
  - `projects/2`: Renders the projects page.
  """

  use PortfolioWeb, :controller
  alias Portfolio.Blog

  @doc """
  Renders the home page.

  ## Parameters

  - `conn`: The connection struct.
  - `_params`: Not used.

  ## Returns

  - The rendered home page.
  """
  def home(conn, _params) do
    case Portfolio.Credly.fetch_data() do
      {:ok, active_badges} ->
        render(conn, :home, badges: active_badges)

      {:error, _message} ->
        render(conn, :home, badges: nil)
    end
  end

  @doc """
  Retrieves a list of blog posts and renders the blog page.

  ## Parameters

  - `conn`: The connection struct.
  - `_params`: Not used.

  ## Returns

  - The rendered blog page with a list of posts.
  """
  def blog(conn, _params) do
    posts = Blog.list_posts()
    render(conn, :blog, posts: posts)
  end

  def show_posts(conn, %{"slug" => slug}) do
    post = Blog.get_post_by_slug!(slug)
    html_content = Earmark.as_html!(post.content)
    render(conn, :show_posts, post: %{post | content: html_content})
  end

  @doc """
  Renders the projects page.

  ## Parameters

  - `conn`: The connection struct.
  - `_params`: Not used.

  ## Returns

  - The rendered projects page.
  """
  def projects(conn, _params) do
    render(conn, :projects)
  end
end

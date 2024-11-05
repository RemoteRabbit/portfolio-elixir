defmodule PortfolioWeb.PageController do
  use PortfolioWeb, :controller
  alias Portfolio.Blog

  def home(conn, _params) do
    render(conn, :home)
  end

  def blog(conn, _params) do
    posts = Blog.list_posts()
    render(conn, :blog, posts: posts)
  end

  def show_posts(conn, %{"slug" => slug}) do
    case Blog.get_post_by_slug(slug) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("404.html")

      post ->
        render(conn, :show_posts, post: post)
    end
  end

  def projects(conn, _params) do
    render(conn, :projects)
  end
end

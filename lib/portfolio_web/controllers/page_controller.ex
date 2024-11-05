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

  def projects(conn, _params) do
    render(conn, :projects)
  end
end

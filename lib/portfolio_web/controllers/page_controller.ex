defmodule PortfolioWeb.PageController do
  use PortfolioWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def blog(conn, _params) do
    render(conn, :blog)
  end

  def projects(conn, _params) do
    render(conn, :projects)
  end
end

defmodule PortfolioWeb.Router do
  @moduledoc """
  This module defines the routes for the PortfolioWeb application.

  The router is responsible for mapping incoming requests to the appropriate controller and action.
  It also sets up pipelines for handling different types of requests (e.g., browser and API requests).

  The `scope` macro is used to define a group of routes that share a common prefix or pipeline.
  The `pipe_through` macro is used to apply a pipeline to a group of routes.

  The routes defined in this module include:

  - `/` - Renders the home page
  - `/blog` - Renders the blog index page
  - `/blog/:slug` - Renders a specific blog post
  - `/projects` - Renders the projects page

  If the application is running in development mode, additional routes are defined for the LiveDashboard
  and Swoosh mailbox preview.
  """

  use PortfolioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PortfolioWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PortfolioWeb do
    pipe_through :browser

    get "/", PageController, :home

    # Blog
    get "/blog", PageController, :blog
    get "/blog/:slug", PageController, :show_posts

    # Projects
    live "/projects", ProjectLive.Index, :index
    live "/projects/:id", ProjectLive.Show, :show
  end

  if Application.compile_env(:portfolio, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PortfolioWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

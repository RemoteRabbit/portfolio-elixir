defmodule PortfolioWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

  use PortfolioWeb, :controller
  use PortfolioWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  @doc """
  Provides the list of static paths for the application.
  """
  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  @doc """
  Defines a quote for the router.
  """
  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  @doc """
  Defines a quote for channels.
  """
  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  @doc """
  Defines a quote for controllers.
  """
  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: PortfolioWeb.Layouts]

      import Plug.Conn
      import PortfolioWeb.Gettext

      unquote(verified_routes())
    end
  end

  @doc """
  Defines a quote for live views.
  """
  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {PortfolioWeb.Layouts, :app}

      unquote(html_helpers())
    end
  end

  @doc """
  Defines a quote for live components.
  """
  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  @doc """
  Defines a quote for HTML components.
  """
  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import PortfolioWeb.CoreComponents
      import PortfolioWeb.Gettext

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: PortfolioWeb.Endpoint,
        router: PortfolioWeb.Router,
        statics: PortfolioWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

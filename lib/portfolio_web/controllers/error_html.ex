defmodule PortfolioWeb.ErrorHTML do
  @moduledoc """
  Module for handling error pages in the PortfolioWeb application.

  This module provides functions for rendering error pages when an error occurs
  in the application. By default, it renders a plain text page based on the
  template name (e.g., "404.html" becomes "Not Found").

  To customize the error pages, you can uncomment the `embed_templates/1` call
  and add pages to the `error` directory, such as:

  * `lib/portfolio_web/controllers/error_html/404.html.heex`
    * `lib/portfolio_web/controllers/error_html/500.html.heex`

  These files can contain HTML templates for rendering more detailed error pages.
  """

  use PortfolioWeb, :html

  # If you want to customize your error pages,
  # uncomment the embed_templates/1 call below
  # and add pages to the error directory:
  #
  #   * lib/portfolio_web/controllers/error_html/404.html.heex
  #   * lib/portfolio_web/controllers/error_html/500.html.heex
  #
  # embed_templates "error_html/*"

  @doc """
  Renders a plain text page based on the template name.

  This function is called when an error occurs and no custom error page is
  provided. It takes the template name (e.g., "404.html") and returns a plain
  text message based on the template name using `Phoenix.Controller.status_message_from_template/1`.

  ## Examples

      iex> PortfolioWeb.ErrorHTML.render("404.html", [])
      "Not Found"

      iex> PortfolioWeb.ErrorHTML.render("500.html", [])
      "Internal Server Error"

  """
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end

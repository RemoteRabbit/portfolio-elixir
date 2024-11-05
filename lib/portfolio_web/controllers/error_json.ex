defmodule PortfolioWeb.ErrorJSON do
  @doc """
  Renders JSON error responses.

  This module is responsible for rendering JSON error responses in case of
  errors during the request processing. It provides a default implementation
  that returns the status message from the template name (e.g., "404.json"
  becomes "Not Found").

  You can customize the error rendering for specific status codes by adding
  clauses to the `render/2` function. For example:

  def render("500.json", _assigns) do
  %{errors: %{detail: "Internal Server Error"}}
  end

  ## Examples

      iex> PortfolioWeb.ErrorJSON.render("404.json", %{})
      %{errors: %{detail: "Not Found"}}

      iex> PortfolioWeb.ErrorJSON.render("500.json", %{})
      %{errors: %{detail: "Internal Server Error"}}

  """

  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end

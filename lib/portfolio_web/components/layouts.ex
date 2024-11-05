defmodule PortfolioWeb.Layouts do
  @moduledoc """
  This module provides layout templates for the Phoenix application.

  The layouts are used to render the main HTML structure of the application,
  including the header, footer, and other common elements.

  The `embed_templates` macro is used to embed the layout templates
  located in the "layouts/*" directory.
  """

  use PortfolioWeb, :html

  embed_templates "layouts/*"
end

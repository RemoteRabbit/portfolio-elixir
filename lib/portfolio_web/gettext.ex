defmodule PortfolioWeb.Gettext do
  @moduledoc """
  A module providing Internationalization with a gettext-based API.

  This module provides a set of macros for translations, including:

  - `gettext/1`: Simple translation of a string.
  - `ngettext/3`: Plural translation of a string, taking a count argument.
  - `dgettext/2`: Domain-based translation of a string, allowing for context-specific translations.

  These macros are based on the [Gettext](https://hexdocs.pm/gettext) library, which provides a
  comprehensive solution for internationalization and localization in Elixir applications.

  ## Examples

  import PortfolioWeb.Gettext

  # Simple translation
  gettext("Here is the string to translate")

  # Plural translation
  ngettext("Here is the string to translate",
  "Here are the strings to translate",
  3)

      # Domain-based translation
      dgettext("errors", "Here is the error message to translate")

  See the [Gettext Docs](https://hexdocs.pm/gettext) for detailed usage and configuration options.
  """
  use Gettext, otp_app: :portfolio
end

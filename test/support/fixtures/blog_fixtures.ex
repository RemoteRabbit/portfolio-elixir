defmodule Portfolio.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Portfolio.Blog` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        context: "some context",
        published_at: ~N[2024-11-04 20:17:00],
        slug: "some slug",
        title: "some title"
      })
      |> Portfolio.Blog.create_post()

    post
  end
end

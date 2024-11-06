defmodule Portfolio.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Portfolio.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        description: "some description",
        featured: true,
        tech_stack: ["option1", "option2"],
        title: "some title",
        url: "some url"
      })
      |> Portfolio.Projects.create_project()

    project
  end
end

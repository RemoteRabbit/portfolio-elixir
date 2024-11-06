defmodule Portfolio.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :tech_stack, {:array, :string}
    field :featured, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title, :description, :url, :tech_stack, :featured])
    |> validate_required([:title, :description, :url, :tech_stack, :featured])
  end
end

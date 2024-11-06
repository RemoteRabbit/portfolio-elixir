defmodule Portfolio.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :string
      add :description, :text
      add :url, :string
      add :tech_stack, {:array, :string}
      add :featured, :boolean, default: false, null: false

      timestamps()
    end
  end
end

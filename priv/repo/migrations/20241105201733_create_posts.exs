defmodule Portfolio.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :slug, :string
      add :context, :text
      add :published_at, :naive_datetime

      timestamps()
    end
  end
end

defmodule Portfolio.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:context, :string)
    field(:title, :string)
    field(:slug, :string)
    field(:published_at, :naive_datetime)
    field(:content, :string, virtual: true)
    field(:date, :date, virtual: true)
    field(:description, :string, virtual: true)
    field(:status, :string, virtual: true)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :slug, :context, :published_at])
    |> validate_required([:title, :slug, :context, :published_at])
  end

  def fetch_posts(owner, repo, path \\ "posts/") do
    case Tentacat.Contents.find(owner, repo, path) do
      {200, contents, _} ->
        contents
        |> Enum.filter(&(&1["type"] == "file" && String.ends_with?(&1["name"], ".md")))
        |> Enum.map(fn file ->
          {200, content, _} = Tentacat.Contents.find(owner, repo, file["path"])

          content["content"]
          |> String.replace("\n", "")
          |> Base.decode64!()
          |> parse_content(file["path"])
        end)
        |> Enum.filter(&(&1.status == "published"))
        |> Enum.sort_by(& &1.date, {:desc, Date})

      {404, _, _} ->
        []

      {status, body, _} ->
        IO.puts("GitHub API returned status #{status}: #{inspect(body)}")
        []
    end
  end

  defp parse_content(content, path) do
    case YamlFrontMatter.parse(content) do
      {:ok, metadata, markdown_content} ->
        # Clean up any potential whitespace or formatting issues
        cleaned_content =
          markdown_content
          |> String.trim()
          |> String.replace(~r/\r\n?/, "\n")

        %__MODULE__{
          title: metadata["title"],
          date: Date.from_iso8601!(metadata["date"]),
          description: metadata["description"],
          content: cleaned_content,
          slug: Path.basename(path, ".md"),
          status: metadata["status"] || "published"
        }

      _ ->
        raise "Invalid blog post format"
    end
  end
end


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

  @doc """
  Fetches blog posts from a GitHub repository.

  This function retrieves the contents of a specified directory in a GitHub repository,
  filters out non-Markdown files, decodes the Base64-encoded content, parses the content,
  filters out unpublished posts, and sorts the posts by date in descending order.

    ## Parameters

    - `owner` (binary): The owner (user or organization) of the GitHub repository.
    - `repo` (binary): The name of the GitHub repository.
    - `path` (binary): The path to the directory containing the blog posts. Defaults to "posts/".

    ## Returns

    - A list of maps representing the parsed blog posts, sorted by date in descending order.
    Each map contains the following keys:
    - `:title` (binary): The title of the blog post.
    - `:date` (Date): The date of the blog post.
    - `:content` (binary): The content of the blog post.
    - `:status` (binary): The status of the blog post (e.g., "published", "draft").
    - `:path` (binary): The path to the Markdown file in the GitHub repository.

  ## Examples

      iex> MyModule.fetch_posts("owner", "repo")
      [
        %{
          title: "My First Post",
          date: ~D[2023-04-01],
          content: "This is the content of my first post.",
          status: "published",
          path: "posts/my-first-post.md"
        },
        %{
          title: "Another Post",
          date: ~D[2023-03-15],
          content: "This is the content of another post.",
          status: "published",
          path: "posts/another-post.md"
        }
      ]

  """
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

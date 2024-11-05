defmodule Portfolio.Blog.Post do
  @moduledoc """
  This module defines a struct to represent a blog post and provides functions
  to fetch and parse blog posts from a GitHub repository.

  ## Struct Fields

  - `title`: The title of the blog post.
  - `content`: The HTML content of the blog post.
  - `date`: The date the blog post was published.
  - `slug`: The slug (URL-friendly version of the title) for the blog post.
  - `description`: A short description of the blog post.
  - `status`: The status of the blog post (e.g., "published", "draft").

  ## Functions

  - `fetch_posts/2`: Fetches blog posts from a GitHub repository.
  - `parse_content/2`: Parses the content of a blog post file.
  """
  defstruct [:title, :content, :date, :slug, :description, :status]

  @doc """
  Fetches blog posts from a GitHub repository.

  This function retrieves the contents of the specified `path` (defaulting to "posts/")
  in the given `owner` and `repo`. It filters the contents to only include Markdown files,
  parses the content of each file, and returns a list of `%Portfolio.Blog.Post{}` structs
  representing the published blog posts, sorted in descending order by date.

  ## Examples

  iex> Portfolio.Blog.Post.fetch_posts("owner", "repo")
  [%Portfolio.Blog.Post{...}, ...]

  iex> Portfolio.Blog.Post.fetch_posts("owner", "repo", "custom/path/")
  [%Portfolio.Blog.Post{...}, ...]

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
        |> Enum.filter(& &1.status == "published")
        |> Enum.sort_by(& &1.date, {:desc, Date})

      {404, _, _} ->
        []

      {status, body, _} ->
        IO.puts "GitHub API returned status #{status}: #{inspect(body)}"
        []
    end
  end

  defp parse_content(content, path) do
    case YamlFrontMatter.parse(content) do
      {:ok, metadata, markdown_content} ->
        %__MODULE__{
          title: metadata["title"],
          date: Date.from_iso8601!(metadata["date"]),
          description: metadata["description"],
          content: Earmark.as_html!(markdown_content),
          slug: Path.basename(path, ".md"),
          status: metadata["status"] || "published"
        }
      _ ->
        raise "Invalid blog post format"
    end
  end
end

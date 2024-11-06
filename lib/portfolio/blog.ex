defmodule Portfolio.Blog do
  @moduledoc """
  This module handles fetching and caching blog posts.

  It uses the ConCache library to cache the list of blog posts for a specified
  time-to-live (TTL) of 1 hour. The `list_posts/0` function retrieves the cached
  posts or fetches them from a remote source if the cache is empty or expired.

  The `get_post_by_slug/1` function retrieves a specific blog post by its slug
  from the cached list of posts.

  The `refresh_cache/0` function clears the cache and fetches the latest blog
  posts from the remote source.
  """

  @cache_ttl :timer.hours(1)

  @doc """
  Retrieves the list of blog posts.

  If the cache is empty or expired, it fetches the posts from a remote source
  and caches them for the specified TTL.

  Returns a list of blog post structs.
  """
  def list_posts do
    case ConCache.get_or_store(:blog_cache, :posts, fn ->
           posts = Portfolio.Blog.Post.fetch_posts("remoterabbit", "blog-posts")
           %{value: posts, ttl: @cache_ttl}
         end) do
      %{value: posts} -> posts
      posts -> posts
    end
  end

  @doc """
  Retrieves a blog post by its slug.

  Searches the cached list of blog posts for a post with the given slug.

  Returns the blog post struct if found, or `nil` if not found.
  """
  def get_post_by_slug!(slug) do
    posts = list_posts()
    Enum.find(posts, fn post -> post.slug == slug end)
  end

  @doc """
  Refreshes the blog post cache.

  Clears the cached list of blog posts and fetches the latest posts from the
  remote source.

  Returns the updated list of blog post structs.
  """
  def refresh_cache do
    ConCache.delete(:blog_cache, :posts)
    list_posts()
  end
end


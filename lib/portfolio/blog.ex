defmodule Portfolio.Blog do
  @cache_ttl :timer.hours(1)

  def list_posts do
    case ConCache.get_or_store(:blog_cache, :posts, fn ->
      posts = Portfolio.Blog.Post.fetch_posts("remoterabbit", "blog-posts")
      %{value: posts, ttl: @cache_ttl}
    end) do
      %{value: posts} -> posts
      posts -> posts
    end
  end

  def get_post_by_slug(slug) do
    list_posts()
    |> Enum.find(&(&1.slug == slug))
  end

  def refresh_cache do
    ConCache.delete(:blog_cache, :posts)
    list_posts()
  end
end


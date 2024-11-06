defmodule Portfolio.BlogTest do
  use Portfolio.DataCase

  alias Portfolio.Blog

  describe "posts" do
    alias Portfolio.Blog.Post

    import Portfolio.BlogFixtures

    @invalid_attrs %{context: nil, title: nil, slug: nil, published_at: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Blog.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{context: "some context", title: "some title", slug: "some slug", published_at: ~N[2024-11-04 20:17:00]}

      assert {:ok, %Post{} = post} = Blog.create_post(valid_attrs)
      assert post.context == "some context"
      assert post.title == "some title"
      assert post.slug == "some slug"
      assert post.published_at == ~N[2024-11-04 20:17:00]
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{context: "some updated context", title: "some updated title", slug: "some updated slug", published_at: ~N[2024-11-05 20:17:00]}

      assert {:ok, %Post{} = post} = Blog.update_post(post, update_attrs)
      assert post.context == "some updated context"
      assert post.title == "some updated title"
      assert post.slug == "some updated slug"
      assert post.published_at == ~N[2024-11-05 20:17:00]
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end
end

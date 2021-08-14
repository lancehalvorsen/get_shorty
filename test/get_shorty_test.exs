defmodule GetShorty.GetShortyTest do
  use ExUnit.Case, async: true

  alias GetShorty.{Repo, Url, UrlFactory}

  @slug_length 8

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    params = %{"url" => %{"original" => "http://google.com"}}

    {:ok, params: params}
  end

  describe "find_or_insert_url/1" do
    test "returns a url record when one with the given orignal url exists" do
      factory_url = UrlFactory.create()
      params = %{"url" => %{"original" => factory_url.original}}
      {:ok, db_url} = GetShorty.find_or_insert_url(params)

      assert db_url.slug == factory_url.slug
      assert db_url.original == factory_url.original
    end

    test "inserts a record when given a valid original url for which no record exists", %{params: params} do
      assert Repo.aggregate(Url, :count) == 0
      {:ok, url} = GetShorty.find_or_insert_url(params)
      assert Repo.aggregate(Url, :count) == 1

      assert url.original == params["url"]["original"]
      assert String.length(url.slug) == @slug_length
    end

    test "returns a changeset with an error when given an invalid original url" do
      params = %{"url" => %{"original" => "google.com"}}

      assert Repo.aggregate(Url, :count) == 0
      {:error, changeset} = GetShorty.find_or_insert_url(params)
      assert Repo.aggregate(Url, :count) == 0

      {_key, {message, _opts}} = List.keyfind(changeset.errors, :original, 0)
      assert message == "URL must begin with http:// or https://"
    end

    test "throws an error when argument is not a map" do
      assert_raise(FunctionClauseError, "no function clause matching in GetShorty.find_or_insert_url/1", fn ->
        GetShorty.find_or_insert_url("http://google.com")
      end)
    end
  end

  describe "fetch_url_by_slug/1" do
    test "returns the record when a record with the given slug exists" do
      factory_url = UrlFactory.create()
      {:ok, db_url} = GetShorty.fetch_url_by_slug(factory_url.slug)

      assert db_url.original == factory_url.original
    end

    test "returns an error when a record with the given slug does not exists" do
      {:error, "url not found"} = GetShorty.fetch_url_by_slug("wrong123")
    end

    test "throws an error when argument is not a string" do
      assert_raise(FunctionClauseError, "no function clause matching in GetShorty.fetch_url_by_slug/1", fn ->
        GetShorty.fetch_url_by_slug(12345678)
      end)
    end
  end
end
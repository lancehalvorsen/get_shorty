defmodule GetShorty.UrlTest do
  use ExUnit.Case, async: true

  alias GetShorty.{Repo, Url, UrlFactory}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GetShorty.Repo)

    {:ok, url: UrlFactory.build()}
  end

  test "is valid with vaid parameters", %{url: url} do
    changeset = Url.changeset(url)
    assert changeset.valid? == true
  end

  describe "slug validations" do
    test "is invalid without a slug", %{url: url} do
      changeset = Url.changeset(url, %{slug: nil})
      assert changeset.valid? == false

      [slug: {message, _}] = changeset.errors
      assert message == "can't be blank"
    end

    test "is invalid if the slug is not a binary", %{url: url} do
      changeset = Url.changeset(url, %{slug: 7})
      assert changeset.valid? == false

      [slug: {message, _}] = changeset.errors
      assert message == "is invalid"
    end

    test "is invalid if the slug is too short", %{url: url} do
      changeset = Url.changeset(url, %{slug: "1234567"})
      assert changeset.valid? == false

      [slug: {message, _}] = changeset.errors
      assert message == "must be exactly 8 characters"
    end

    test "is invalid if the slug is too longt", %{url: url} do
      changeset = Url.changeset(url, %{slug: "123456789"})
      assert changeset.valid? == false

      [slug: {message, _}] = changeset.errors
      assert message == "must be exactly 8 characters"
    end

    test "is invalid if the slug is not unique", %{url: url} do
      UrlFactory.create()
      changeset = Url.changeset(url, %{original: "https://somethingelse.com"})
      {:error, changeset} = Repo.insert(changeset)

      assert changeset.valid? == false
      [slug: {message, _}] = changeset.errors
      assert message == "has already been taken"
    end
  end

  describe "original url validations" do
    test "is invalid without an original url", %{url: url} do
      changeset = Url.changeset(url, %{original: nil})
      assert changeset.valid? == false

      [original: {message, _}] = changeset.errors
      assert message == "can't be blank"
    end

    test "is invalid if the original url is not a binary", %{url: url} do
      changeset = Url.changeset(url, %{original: [1]})
      assert changeset.valid? == false

      [original: {message, _}] = changeset.errors
      assert message == "is invalid"
    end

    test "is invalid if the original url is not unique", %{url: url} do
      UrlFactory.create()
      changeset = Url.changeset(url, %{slug: "87654321"})
      {:error, changeset} = Repo.insert(changeset)
      
      assert changeset.valid? == false
      [original: {message, _}] = changeset.errors
      assert message == "has already been taken"
    end

    test "is invalid if the original url does not contain a scheme", %{url: url} do
      changeset = Url.changeset(url, %{original: "google.com"})
      assert changeset.valid? == false

      [original: {message, _}] = changeset.errors
      assert message == "URL must begin with http:// or https://"
    end

    test "is invalid if the original url does not contain a valid host", %{url: url} do
      changeset = Url.changeset(url, %{original: "http://googlecom"})
      assert changeset.valid? == false

      [original: {message, _}] = changeset.errors
      assert message == "The URL's host must contain a dot"
    end
  end
end
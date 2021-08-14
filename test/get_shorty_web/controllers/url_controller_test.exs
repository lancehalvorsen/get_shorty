defmodule GetShortyWeb.UrlControllerTest do
  use GetShortyWeb.ConnCase

  alias GetShorty.{Repo, Url, UrlFactory}

  describe "the new action" do
    test "GET / renders the correct template", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Get Shorty, the URL shortener of your dreams."
    end
  end

  describe "the create action" do
    test "returns an existing URL if the original matches a record in the db", %{conn: conn} do
      %Url{slug: slug, original: original} = UrlFactory.create()
      conn = post(conn, "/api/url", url: %{"original" => original})
      assert Repo.aggregate(Url, :count) == 1

      assert %{"errors" => nil, "slug" => ^slug} = json_response(conn, 201)
    end

    test "creates a new record and returns it if nothing matches the original in the db", %{conn: conn} do
      assert Repo.aggregate(Url, :count) == 0
      conn = post(conn, "/api/url", url: %{"original" => "https://google.com"})
      %Url{slug: slug} = Repo.one!(Url)

      assert %{"errors" => nil, "slug" => ^slug} = json_response(conn, 201)
    end

    test "returns an error with a malformed original, doesn't create a record in the db", %{conn: conn} do
      conn = post(conn, "/api/url", url: %{"original" => "google.com"})
      assert Repo.aggregate(Url, :count) == 0
      assert %{"errors" => "URL must begin with http:// or https://", "slug" => nil} = json_response(conn, 200)
    end
  end

  describe "the show action" do
    test "redirects to the original URL when the slug matches a record in the db", %{conn: conn} do
      url = UrlFactory.create()
      conn = get(conn, "/#{url.slug}")
      assert redirected_to(conn) == url.original
    end

    test "responds with 404 not found when no slug matches a record in the db", %{conn: conn} do
      conn = get(conn, "/totallywrong")
      assert html_response(conn, 404)
    end
  end
end

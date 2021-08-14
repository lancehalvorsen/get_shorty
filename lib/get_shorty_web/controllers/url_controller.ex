defmodule GetShortyWeb.UrlController do
  use GetShortyWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, params) do
    case GetShorty.find_or_insert_url(params) do
      {:ok, url} ->
        conn
        |> put_status(:created)
        |> json(%{slug: url.slug, errors: nil})
      {:error, changeset} ->
        json(conn, %{slug: nil, errors: extract_errors(changeset)})
    end
  end

  def show(conn, params) do
    case GetShorty.fetch_url_by_slug(params["id"]) do
      {:ok, url} -> 
        redirect(conn, external: url.original)
      {:error, _reason} ->
        conn
        |> put_status(:not_found)
        |> put_view(GetShortyWeb.ErrorView)
        |> render(:"404")
    end
  end

  defp extract_errors(changeset) do
    case List.keytake(changeset.errors, :original, 0) do
      nil -> "An unknown error occurred."
      {{:original, {message, []}}, []} -> message
    end
  end
end
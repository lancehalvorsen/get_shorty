defmodule GetShorty.UrlFactory do
  alias GetShorty.{Repo, Url}

  def build(attrs \\ %{}) when is_map(attrs) do
    Map.merge(defaults(), attrs)
  end

  def create(attrs \\ %{}) when is_map(attrs) do
    attrs
    |> build()
    |> Repo.insert!()
  end

  defp defaults(), do: %Url{slug: "12345678", original: "https://google.com"}
end
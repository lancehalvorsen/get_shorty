defmodule GetShorty do

  alias GetShorty.{Repo, Url}

  @number_of_random_bytes 128
  @slug_length 8

  def find_or_insert_url(params) when is_map(params) do
    original = params["url"]["original"]
    case fetch_url_by_original(original) do
      {:ok, url} ->
        {:ok, url}
      {:error, _reason} ->
        insert_url(original)
    end
  end

  # Repo.get_by/2 parameterizes queries, so we don't have to.
  def fetch_url_by_slug(slug) when is_binary(slug) do
    case Repo.get_by(Url, slug: slug) do
      nil -> {:error, "url not found"}
      url -> {:ok, url}
    end
  end

  defp fetch_url_by_original(original) when is_binary(original) do
    case Repo.get_by(Url, original: original) do
      nil -> {:error, "url not found"}
      url -> {:ok, url}
    end
  end

  defp insert_url(original) do
    changes = %{original: original, slug: generate_slug()}

    %Url{}
    |> Url.changeset(changes)
    |> Repo.insert()
  end

  defp generate_slug() do
    @number_of_random_bytes
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, @slug_length)
  end
end

defmodule GetShorty.Url do
  use Ecto.Schema

  import Ecto.Changeset

  schema "urls" do
    field :slug, :string
    field :original, :string
    timestamps()
  end

  def changeset(url, params \\ %{}) do
    url
    |> cast(params, [:slug, :original])
    |> validate_required([:slug, :original])
    |> unique_constraint(:slug)
    |> unique_constraint(:original)
    |> validate_length(:slug, is: 8, message: "must be exactly 8 characters")
    |> validate_url()
  end

  defp validate_url(changeset) do
    validate_change(changeset, :original, fn :original, original  ->
      url = URI.parse(original)

      cond do
        invalid_scheme?(url.scheme) ->
          [original: "URL must begin with http:// or https://"]
        invalid_host?(url.host) ->
          [original: "The URL's host must contain a dot"]
        true ->
          []
      end
    end)
  end

  defp invalid_scheme?(scheme) do
    !Enum.any?(["http", "https"], fn element ->
      element == scheme
    end)
  end

  defp invalid_host?(host) do
    cond do
      is_nil(host) -> true
      !String.match?(host, ~r/\./) -> true
      true -> false
    end
  end
end
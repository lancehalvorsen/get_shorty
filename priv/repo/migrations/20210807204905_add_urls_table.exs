defmodule GetShorty.Repo.Migrations.AddUrlsTable do
  use Ecto.Migration

  def change do
    create table("urls") do
      add :slug, :string, size: 8
      add :original, :text

      timestamps()
    end 

    create index("urls", [:slug], unique: true)
    create index("urls", [:original], unique: true)
  end
end

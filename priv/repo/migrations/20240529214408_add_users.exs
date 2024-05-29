defmodule Discuss.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      # store the users email
      add :email, :string
      # store the provider used, ex: github, twitter, etc.
      add :provider, :string
      # token from OAuth identifying the user
      add :token, :string

      timestamps()
    end
  end
end

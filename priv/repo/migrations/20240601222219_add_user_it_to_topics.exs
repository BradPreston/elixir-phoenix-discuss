defmodule Discuss.Repo.Migrations.AddUserItToTopics do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      # creates a column called user_id which references the users table
      add :user_id, references(:users)
    end
  end
end

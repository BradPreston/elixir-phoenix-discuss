defmodule Discuss.Repo.Migrations.AddTopics do
  use Ecto.Migration

  def change do
    # create a new table called 'topics'
    create table(:topics) do
      # make sure there is a column called 'title' with a type of 'string'
      add :title, :string
    end
  end
end

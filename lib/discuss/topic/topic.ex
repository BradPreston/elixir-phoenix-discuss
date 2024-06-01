defmodule Discuss.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  # look up a database called topics
  schema "topics" do
    # the table should have a column called title where every value is a string
    field :title, :string
    # a topic can belong to only one user
    belongs_to :user, Discuss.User
  end

  # struct is a hash that represents a record in the database
  # params is a hash that contains the properties we want to update the struct (databse record) with
  # double backslash is how to set default values in Elixir. If nil was passed in as params, an empty
  # struct would be created instead
  def changeset(struct, params \\ %{}) do
    struct
    # case produces and returns a changeset.
    # A changeset records the updates to the database we are trying to make
    # aka, it takes the data from what it is and casts it into what it needs to be
    |> cast(params, [:title])
    # checks that the title is valid
    # aka, it makes sure the title is of type 'string'
    |> validate_required([:title])
  end

  # NOTE:
  # The changeset returned contains action, changes, errors, data, and valid fields
  # Changes is a map of the changes to be implemented on the database record
  # Errors is a list of errors to be returned from the changeset
  # Valid verifies that the changes to be implemented are valid
end

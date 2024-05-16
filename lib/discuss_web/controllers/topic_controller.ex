defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render(conn, :new, changeset: changeset)
  end

  # instead of using params, we pattern match the topic key out
  # of the params object. Now we have access to topic (and only topic)
  # in the create function
  def create(conn, %{"topic" => topic}) do
  end
end

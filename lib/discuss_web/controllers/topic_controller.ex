defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic
  alias Discuss.Repo
  # alias DiscussWeb.Router.Helpers, as: Routes

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render(conn, :index, topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render(conn, :new, changeset: changeset)
  end

  # instead of using params, we pattern match the topic key out
  # of the params object. Now we have access to topic (and only topic)
  # in the create function
  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Topic created")
        |> redirect(to: ~p"/topics")

      # tightly couples the form with the changeset. If any errors occur,
      # the form will display the errors to the user
      {:error, changeset} ->
        conn
        |> put_flash(:error, "An issue occurred")
        |> render(:new, changeset: changeset)
    end
  end
end

defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic
  alias Discuss.Repo

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

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
    # changeset contains a user and associates this user with a created topic
    changeset =
      conn.assigns.user
      # pass current user into build_assoc, which creates a Topic struct
      |> Ecto.build_assoc(:topics)
      # topic struct piped into changeset has a reference to current user
      |> Topic.changeset(topic)

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

  # edit is used to show the form to edit a topic
  # pattern match id into a variable called topic_id. id comes from
  # the route wildcard that we called id: /topics/:id/edit
  def edit(conn, %{"id" => topic_id}) do
    # SELECT FROM topics WHERE id = topic_id
    topic = Repo.get(Topic, topic_id)
    # if changeset params is null (like it is here), the changeset
    # creates an empty map (%{})
    changeset = Topic.changeset(topic)
    # render the edit template (edit.html.heex) and pass in the
    # changeset and topic from database
    render(conn, :edit, changeset: changeset, topic: topic)
  end

  # update is used to update the topic in the database with the new data
  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: ~p"/topics")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "An issue occurred")
        |> render(:edit, changeset: changeset, topic: old_topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    # get! (get bang) will raise an error if getting the
    # topic encounters any issue
    Repo.get!(Topic, topic_id)
    # delete! (delete bang) will also raise an error if
    # something does go wrong
    |> Repo.delete!()

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: ~p"/topics")
  end
end

defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.User
  alias Discuss.Repo

  # this callback function is required by Ueberauth to be implemented
  # pattern match the ueberauth_auth struct into a variable called auth from conn
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    # grab the required values from the auth struct
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: "github"
    }

    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    # drop all session data related to user from session
    |> configure_session(drop: true)
    |> redirect(to: ~p"/topics")
  end

  # private function to handle signing in a user via cookies
  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        # put session stores the user id which makes it
        # easier to work with cookies
        |> put_session(:user_id, user.id)
        |> redirect(to: ~p"/topics")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: ~p"/topics")
    end
  end

  # private function that
  # 1. checks if a user exists and updates the token, or
  # 2. creates a new user with a new token in the database
  defp insert_or_update_user(changeset) do
    # SELECT FROM users WHERE email = changeset.changes.email
    case Repo.get_by(User, email: changeset.changes.email) do
      # both cases return {:ok, struct} except Repo.insert returns
      # {:error, changeset} if an error occurs
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end
end

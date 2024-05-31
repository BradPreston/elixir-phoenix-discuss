# SetUser plug either successfully grabs a user from the database and
# adds the user data to the assigns struct with the key user, or assigns
# the key user with the value nil in the assigns struct if no user was found.
defmodule Discuss.Plugs.SetUser do
  import Plug.Conn

  alias Discuss.Repo
  alias Discuss.User

  # no init required for this plug, therefore no params will
  # be returned. init is great for expensive calls, like a
  # call to the database that needs a lot of computations on it.
  # init would run only once to grab the required data.
  def init(_params) do
  end

  # params is NOT the same params as a controller function,
  # instead params is the return value from the init function.
  # call is called every time a connection is made to our pipeline.
  # it MUST return a conn
  def call(conn, _params) do
    # get the user id from the session
    user_id = get_session(conn, :user_id)

    # condition statement
    # similar to a case, except that code runs when the first
    # condition is true
    cond do
      # if user_id exists AND user exists in database,
      # assign the user from the database to the variable: user
      user = user_id && Repo.get(User, user_id) ->
        # adds the user data with the key user to the assigns
        # struct to use throughout the application. Any plug
        # after this plug will have access to user via the
        # assigns struct
        assign(conn, :user, user)

      # otherwise, run this code (true is similar to default)
      true ->
        # adds the key user with the data nil to the assigns struct
        assign(conn, :user, nil)
    end
  end
end

# RequireAuth plug makes sure that a user has access to
# the required data
defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  # called once for the entirety of the application lifecycle
  def init(_params) do
  end

  # called everytime a request flows through the plug
  def call(conn, _params) do
    if conn.assigns[:user] do
      # a user is logged in, so continue down the conn pipeline
      conn
    else
      # a user is not logged in
      conn
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: "/topics")
      |> halt()
    end
  end
end

defmodule MvpVendingApiWeb.SessionController do
  use MvpVendingApiWeb, :controller

  alias MvpVendingApi.Accounts
  alias MvpVendingApi.Accounts.User

  action_fallback MvpVendingApiWeb.FallbackController

  def create(conn, %{"username" => username, "password" => password}) do
    with %User{} = user <- Accounts.get_user_by_username_and_password(username, password),
         {:ok, jwt, _claims} <-
           MvpVendingApi.Guardian.encode_and_sign(
             user,
             %{
               username: user.username,
               role: user.role
             }
           ) do
      conn
      |> render("show.json", user: user, token: jwt)
    else
      error ->
        IO.inspect(error)
        render(conn, MvpVendingApiWeb.ErrorView, "error.json", %{message: "invalid credentials"})
    end
  end

  def index(conn, _params) do
    user = MvpVendingApi.Guardian.Plug.current_resource(conn)
    render(conn, "me.json", user: user)
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end

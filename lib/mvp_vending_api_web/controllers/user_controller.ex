defmodule MvpVendingApiWeb.UserController do
  use MvpVendingApiWeb, :controller

  alias MvpVendingApi.Accounts
  alias MvpVendingApi.Accounts.User

  action_fallback MvpVendingApiWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def deposit(conn, %{"amount" => amount}) do
    user = MvpVendingApi.Guardian.Plug.current_resource(conn)

    with {:ok, %User{} = user} <-
           Accounts.update_user_deposit(user, %{deposit: user.deposit + amount}) do
      render(conn, "show.json", user: user)
    end
  end

  def reset_deposit(conn, _params) do
    user = MvpVendingApi.Guardian.Plug.current_resource(conn)

    with {:ok, %User{} = user} <-
           Accounts.update_user_deposit(user, %{deposit: 0}) do
      render(conn, "show.json", user: user)
    else
      {_, changeset} ->
        render(conn, MvpVendingApiWeb.ErrorView, "error.json", %{changeset: changeset})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    else
      {_, changeset} ->
        render(conn, MvpVendingApiWeb.ErrorView, "error.json", %{changeset: changeset})
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def valid_amount?(amount), do: Enum.member?([5, 10, 20, 50, 100], amount)
end

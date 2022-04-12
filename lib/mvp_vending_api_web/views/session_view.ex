defmodule MvpVendingApiWeb.SessionView do
  use MvpVendingApiWeb, :view
  alias MvpVendingApiWeb.UserView

  def render("show.json", %{user: user, token: token}) do
    %{user: render_one(user, UserView, "user.json"), token: token}
  end

  def render("me.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      deposit: user.deposit,
      role: user.role
    }
  end
end

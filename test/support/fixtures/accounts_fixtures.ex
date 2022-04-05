defmodule MvpVendingApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MvpVendingApi.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        deposit: 42,
        hashed_password: "some hashed_password",
        role: "some role",
        username: "some username"
      })
      |> MvpVendingApi.Accounts.create_user()

    user
  end
end

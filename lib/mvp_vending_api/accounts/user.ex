defmodule MvpVendingApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string, null: false
    field :hashed_password, :string, null: false
    field :deposit, :integer, default: 0
    field :role, Ecto.Enum, values: [:seller, :buyer]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :hashed_password, :deposit, :role])
    |> validate_required([:username, :hashed_password, :deposit, :role])
  end
end

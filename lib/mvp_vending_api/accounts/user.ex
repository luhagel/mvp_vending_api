defmodule MvpVendingApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string, null: false
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :deposit, :integer, default: 0
    field :role, Ecto.Enum, values: [:seller, :buyer]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :hashed_password, :deposit, :role])
    |> validate_required([:username, :hashed_password, :deposit, :role])
    |> put_change(:deposit, 0)
    |> unique_constraint(:username)
  end

  @doc false
  def register_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role])
    |> validate_required([:username, :password, :role])
  end

  @doc false
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
  end

  @doc false
  def deposit_changeset(user, attrs) do
    user
    |> cast(attrs, [:deposit])
    |> validate_required([:deposit])
  end
end

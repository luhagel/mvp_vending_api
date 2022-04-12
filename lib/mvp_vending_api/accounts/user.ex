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
    |> cast(attrs, [:username, :password, :deposit, :role])
    |> validate_required([:username, :password, :deposit, :role])
    |> put_change(:deposit, 0)
    |> unique_constraint(:username)
    |> validate_password([])
  end

  @doc false
  def register_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role])
    |> validate_required([:username, :password, :role])
    |> put_change(:deposit, 0)
    |> unique_constraint(:username)
    |> validate_password([])
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

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 72)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Argon2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  Verifies the password.
  If there is no user or the user doesn't have a password, we call
  `Argon2.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%MvpVendingApi.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Argon2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Argon2.no_user_verify()
    false
  end
end

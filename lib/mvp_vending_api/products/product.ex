defmodule MvpVendingApi.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias MvpVendingApi.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :name, :string, null: false
    field :cost, :integer, null: false
    field :amount_available, :integer, default: 0

    belongs_to :seller, User, foreign_key: :seller_id

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :amount_available, :cost, :seller_id])
    |> validate_required([:name, :amount_available, :cost, :seller_id])
    |> cast_assoc(:seller)
  end
end

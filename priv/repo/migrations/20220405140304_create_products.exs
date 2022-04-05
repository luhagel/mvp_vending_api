defmodule MvpVendingApi.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :amount_available, :integer
      add :cost, :integer

      add :seller_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end

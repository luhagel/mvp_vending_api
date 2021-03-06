defmodule MvpVendingApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  @create_user_role "CREATE TYPE user_role AS ENUM ('seller', 'buyer')"
  @drop_user_role "DROP TYPE user_role"

  def change do
    execute(@create_user_role, @drop_user_role)

    create table(:users) do
      add :username, :string, null: false
      add :hashed_password, :string, null: false
      add :deposit, :integer, default: 0
      add :role, :user_role, null: false

      timestamps()
    end

    create unique_index(:users, [:username])
  end
end

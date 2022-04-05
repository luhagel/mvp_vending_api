defmodule MvpVendingApi.Repo do
  use Ecto.Repo,
    otp_app: :mvp_vending_api,
    adapter: Ecto.Adapters.Postgres
end

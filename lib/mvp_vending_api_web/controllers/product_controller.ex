defmodule MvpVendingApiWeb.ProductController do
  use MvpVendingApiWeb, :controller

  alias MvpVendingApi.Accounts
  alias MvpVendingApi.Products
  alias MvpVendingApi.Products.Product

  action_fallback MvpVendingApiWeb.FallbackController

  def index(conn, _params) do
    products = Products.list_products()
    render(conn, "index.json", products: products)
  end

  def create(conn, %{"product" => product_params}) do
    user = MvpVendingApi.Guardian.Plug.current_resource(conn)
    product_params = Map.put(product_params, "seller_id", user.id)

    with {:ok, %Product{} = product} <- Products.create_product(product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.product_path(conn, :show, product))
      |> render("show.json", product: product)
    end
  end

  def buy(conn, %{"product_id" => product_id, "amount" => amount}) do
    user = MvpVendingApi.Guardian.Plug.current_resource(conn)
    product = Products.get_product!(product_id)

    total_price = product.cost * amount

    case total_price > user.deposit do
      true ->
        send_resp(conn, 400, "not enough money available")

      false ->
        Products.update_product(product, %{amount_available: product.amount_available - amount})
        Accounts.update_user_deposit(user, %{deposit: user.deposit - total_price})
        send_resp(conn, :ok, "successfully bought #{amount} #{product.name}")
    end
  end

  def show(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    render(conn, "show.json", product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Products.get_product!(id)

    with {:ok, %Product{} = product} <- Products.update_product(product, product_params) do
      render(conn, "show.json", product: product)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Products.get_product!(id)

    with {:ok, %Product{}} <- Products.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end
end

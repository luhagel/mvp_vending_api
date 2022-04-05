defmodule MvpVendingApi.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MvpVendingApi.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        amount_available: 42,
        cost: 42,
        name: "some name"
      })
      |> MvpVendingApi.Products.create_product()

    product
  end
end

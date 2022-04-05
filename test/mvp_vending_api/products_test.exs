defmodule MvpVendingApi.ProductsTest do
  use MvpVendingApi.DataCase

  alias MvpVendingApi.Products

  describe "products" do
    alias MvpVendingApi.Products.Product

    import MvpVendingApi.ProductsFixtures

    @invalid_attrs %{amount_available: nil, cost: nil, name: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{amount_available: 42, cost: 42, name: "some name"}

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.amount_available == 42
      assert product.cost == 42
      assert product.name == "some name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{amount_available: 43, cost: 43, name: "some updated name"}

      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.amount_available == 43
      assert product.cost == 43
      assert product.name == "some updated name"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end

defmodule Tenant.CatalogTest do
  use Tenant.DataCase

  alias Tenant.Catalog

  describe "categories" do
    alias Tenant.Catalog.Category

    @valid_attrs %{name: "some name", tenant_id: 1}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil, tenant_id: nil}

    test "list_categories/0 returns all categories for default tenant" do
      tenant_categories = insert_list(3, :category, tenant_id: 1)
      other_categories = insert_list(3, :category, tenant_id: 2)
      result = Catalog.list_categories()
      category_ids = result |> Enum.map(& &1.id) |> MapSet.new()

      assert length(result) == 3

      for category <- tenant_categories do
        assert MapSet.member?(category_ids, category.id)
      end

      for category <- other_categories do
        refute MapSet.member?(category_ids, category.id)
      end
    end

    test "get_category!/1 returns the category with given id" do
      category = insert(:category)
      assert Catalog.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Catalog.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = insert(:category)
      assert {:ok, %Category{} = category} = Catalog.update_category(category, @update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = insert(:category)
      assert {:error, %Ecto.Changeset{}} = Catalog.update_category(category, @invalid_attrs)
      assert category == Catalog.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = insert(:category)
      assert {:ok, %Category{}} = Catalog.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = insert(:category)
      assert %Ecto.Changeset{} = Catalog.change_category(category)
    end
  end

  describe "products" do
    alias Tenant.Catalog.Product

    @valid_attrs %{name: "some name", tenant_id: 1}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil, tenant_id: nil}

    test "list_products/0 returns all products" do
      tenant_products = insert_list(3, :product, tenant_id: 1)
      other_products = insert_list(3, :product, tenant_id: 2)
      result = Catalog.list_products()
      product_ids = result |> Enum.map(& &1.id) |> MapSet.new()

      assert length(result) == 3

      for product <- tenant_products do
        assert MapSet.member?(product_ids, product.id)
      end

      for product <- other_products do
        refute MapSet.member?(product_ids, product.id)
      end
    end

    test "get_product!/1 returns the product with given id" do
      product = insert(:product, category: nil)
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Catalog.create_product(@valid_attrs)
      assert product.name == "some name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = insert(:product)
      assert {:ok, %Product{} = product} = Catalog.update_product(product, @update_attrs)
      assert product.name == "some updated name"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = insert(:product, category: nil)
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = insert(:product)
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = insert(:product)
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end
end

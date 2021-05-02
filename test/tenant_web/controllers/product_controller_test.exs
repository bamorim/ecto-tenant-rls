defmodule TenantWeb.ProductControllerTest do
  use TenantWeb.ConnCase

  @create_attrs %{name: "some name", tenant_id: 1}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil, tenant_id: nil}

  defmacrop test_form_fields(do: build_response) do
    quote do
      categories = insert_list(3, :category)
      response = unquote(build_response)

      for category <- categories do
        assert response =~ category.name
      end
    end
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      category = insert(:category)
      product = insert(:product, category: category)
      insert(:product)
      conn = get(conn, Routes.product_path(conn, :index))
      response = html_response(conn, 200)
      assert response =~ "Listing Products"
      assert response =~ product.name
      assert response =~ category.name
    end
  end

  describe "new product" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :new))
      assert html_response(conn, 200) =~ "New Product"
    end

    test "renders form fields correctly", %{conn: conn} do
      test_form_fields do
        conn = get(conn, Routes.product_path(conn, :new))
        html_response(conn, 200)
      end
    end
  end

  describe "viewing product" do
    test "shows category name", %{conn: conn} do
      category = insert(:category)
      product = insert(:product, category: category)
      conn = get(conn, Routes.product_path(conn, :show, product.id))
      response = html_response(conn, 200)
      assert response =~ "Show Product"
      assert response =~ product.name
      assert response =~ category.name
    end
  end

  describe "create product" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), product: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.product_path(conn, :show, id)

      conn = get(conn, Routes.product_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Product"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), product: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Product"
    end

    test "renders form fields correctly", %{conn: conn} do
      test_form_fields do
        conn = post(conn, Routes.product_path(conn, :create), product: @invalid_attrs)
        html_response(conn, 200)
      end
    end
  end

  describe "edit product" do
    setup [:create_product]

    test "renders form for editing chosen product", %{conn: conn, product: product} do
      conn = get(conn, Routes.product_path(conn, :edit, product))
      assert html_response(conn, 200) =~ "Edit Product"
    end
  end

  describe "update product" do
    setup [:create_product]

    test "redirects when data is valid", %{conn: conn, product: product} do
      conn = put(conn, Routes.product_path(conn, :update, product), product: @update_attrs)
      assert redirected_to(conn) == Routes.product_path(conn, :show, product)

      conn = get(conn, Routes.product_path(conn, :show, product))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, Routes.product_path(conn, :update, product), product: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Product"
    end

    test "renders form fields correctly", %{conn: conn, product: product} do
      test_form_fields do
        conn = put(conn, Routes.product_path(conn, :update, product), product: @invalid_attrs)
        html_response(conn, 200)
      end
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete(conn, Routes.product_path(conn, :delete, product))
      assert redirected_to(conn) == Routes.product_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.product_path(conn, :show, product))
      end
    end
  end

  defp create_product(_) do
    product = insert(:product)
    %{product: product}
  end
end

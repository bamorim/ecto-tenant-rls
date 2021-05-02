defmodule TenantWeb.CategoryControllerTest do
  use TenantWeb.ConnCase

  @create_attrs %{name: "some name", tenant_id: 1}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil, tenant_id: nil}

  describe "index" do
    test "lists all categories for default tenant", %{conn: conn} do
      tenant_categories = insert_list(3, :category, tenant_id: 1)
      other_categories = insert_list(3, :category, tenant_id: 2)
      conn = get(conn, Routes.category_path(conn, :index))
      response = html_response(conn, 200)
      assert response =~ "Listing Categories"

      for category <- tenant_categories do
        assert response =~ category.name
      end

      for category <- other_categories do
        refute response =~ category.name
      end
    end

    test "lists all categories for specified tenant tenant", %{conn: conn} do
      tenant_categories = insert_list(3, :category, tenant_id: 2)
      other_categories = insert_list(3, :category, tenant_id: 1)
      conn = get(conn, Routes.category_path(conn, :index, tenant_id: 2))
      response = html_response(conn, 200)
      assert response =~ "Listing Categories"

      for category <- tenant_categories do
        assert response =~ category.name
      end

      for category <- other_categories do
        refute response =~ category.name
      end
    end
  end

  describe "new category" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.category_path(conn, :new))
      assert html_response(conn, 200) =~ "New Category"
    end
  end

  describe "create category" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.category_path(conn, :create), category: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.category_path(conn, :show, id)

      conn = get(conn, Routes.category_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Category"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.category_path(conn, :create), category: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Category"
    end
  end

  describe "edit category" do
    setup [:create_category]

    test "renders form for editing chosen category", %{conn: conn, category: category} do
      conn = get(conn, Routes.category_path(conn, :edit, category))
      assert html_response(conn, 200) =~ "Edit Category"
    end
  end

  describe "update category" do
    setup [:create_category]

    test "redirects when data is valid", %{conn: conn, category: category} do
      conn = put(conn, Routes.category_path(conn, :update, category), category: @update_attrs)
      assert redirected_to(conn) == Routes.category_path(conn, :show, category)

      conn = get(conn, Routes.category_path(conn, :show, category))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, category: category} do
      conn = put(conn, Routes.category_path(conn, :update, category), category: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Category"
    end
  end

  describe "delete category" do
    setup [:create_category]

    test "deletes chosen category", %{conn: conn, category: category} do
      conn = delete(conn, Routes.category_path(conn, :delete, category))
      assert redirected_to(conn) == Routes.category_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.category_path(conn, :show, category))
      end
    end
  end

  defp create_category(_) do
    category = insert(:category, tenant_id: 1)
    %{category: category}
  end
end

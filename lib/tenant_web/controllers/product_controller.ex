defmodule TenantWeb.ProductController do
  use TenantWeb, :controller

  alias Tenant.Catalog
  alias Tenant.Catalog.Product

  def index(conn, _params) do
    products = Catalog.list_products()
    render(conn, "index.html", products: products)
  end

  def new(conn, _params) do
    categories = Catalog.list_categories()
    changeset = Catalog.change_product(%Product{})
    render(conn, "new.html", changeset: changeset, categories: categories)
  end

  def create(conn, %{"product" => product_params}) do
    case Catalog.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: Routes.product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        categories = Catalog.list_categories()
        render(conn, "new.html", changeset: changeset, categories: categories)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    categories = Catalog.list_categories()
    product = Catalog.get_product!(id)
    changeset = Catalog.change_product(product)
    render(conn, "edit.html", product: product, changeset: changeset, categories: categories)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Catalog.get_product!(id)

    case Catalog.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: Routes.product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        categories = Catalog.list_categories()
        render(conn, "edit.html", product: product, changeset: changeset, categories: categories)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    {:ok, _product} = Catalog.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: Routes.product_path(conn, :index))
  end
end

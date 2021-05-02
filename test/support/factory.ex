defmodule Tenant.Factory do
  use ExMachina
  use Tenant.EctoStrategy, repo: Tenant.Repo

  alias Tenant.Catalog.Category
  alias Tenant.Catalog.Product

  def category_factory do
    %Category{
      name: sequence("category"),
      tenant_id: 1
    }
  end

  def product_factory do
    %Product{
      name: sequence("product"),
      tenant_id: 1
    }
  end
end

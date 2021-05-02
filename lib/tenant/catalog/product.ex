defmodule Tenant.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tenant.Catalog.Category

  schema "products" do
    field :name, :string
    field :tenant_id, :integer
    belongs_to :category, Category

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :tenant_id, :category_id])
    |> validate_required([:name, :tenant_id])
  end
end

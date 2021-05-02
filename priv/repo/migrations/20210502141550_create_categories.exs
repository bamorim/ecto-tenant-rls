defmodule Tenant.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :tenant_id, :integer

      timestamps()
    end
  end
end

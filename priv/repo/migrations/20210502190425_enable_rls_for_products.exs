defmodule Tenant.Repo.Migrations.EnableRlsForProducts do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE products ENABLE ROW LEVEL SECURITY;",
            "ALTER TABLE products DISABLE ROW LEVEL SECURITY;"

    execute "ALTER TABLE products FORCE ROW LEVEL SECURITY;",
            "ALTER TABLE products NO FORCE ROW LEVEL SECURITY;"

    execute """
              CREATE POLICY products_multi_tenancy ON products
              USING (COALESCE(current_setting('app.current_tenant_id', true), '') = '' OR tenant_id::text = current_setting('app.current_tenant_id', true));
            """,
            "DROP POLICY products_multi_tenancy ON products;"
  end
end

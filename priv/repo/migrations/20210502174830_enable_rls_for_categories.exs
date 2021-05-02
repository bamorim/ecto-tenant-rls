defmodule Tenant.Repo.Migrations.EnableRlsForCategories do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE categories ENABLE ROW LEVEL SECURITY;",
            "ALTER TABLE categories DISABLE ROW LEVEL SECURITY;"

    execute "ALTER TABLE categories FORCE ROW LEVEL SECURITY;",
            "ALTER TABLE categories NO FORCE ROW LEVEL SECURITY;"

    execute """
              CREATE POLICY categories_multi_tenancy ON categories
              USING (COALESCE(current_setting('app.current_tenant_id', true)::text, '') = '' OR tenant_id::text = current_setting('app.current_tenant_id', true));
            """,
            "DROP POLICY categories_multi_tenancy ON categories;"
  end
end

defmodule Tenant.Repo do
  use Ecto.Repo,
    otp_app: :tenant,
    adapter: Ecto.Adapters.Postgres

  def tenant_checkout(tenant_id, callback) do
    checkout(fn ->
      query!("SELECT set_config('app.current_tenant_id', $1::text, false);", [to_string(tenant_id)], [])
      result = callback.()
      query!("SET LOCAL app.current_tenant_id TO '';")
      result
    end)
  end
end

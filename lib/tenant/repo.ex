defmodule Tenant.Repo do
  use Ecto.Repo,
    otp_app: :tenant,
    adapter: Ecto.Adapters.Postgres

  def tenant_checkout(tenant_id \\ Process.get(:tenant_id, 1), callback) do
    checkout(fn ->
      set_tenant(tenant_id)
      result = callback.()
      reset_tenant()
      result
    end)
  end

  def set_tenant(tenant_id) do
    query!(
      "SELECT set_config('app.current_tenant_id', $1::text, false);",
      [to_string(tenant_id)],
      []
    )
  end

  def reset_tenant do
    query!("SELECT set_config('app.current_tenant_id', '', false);")
  end
end

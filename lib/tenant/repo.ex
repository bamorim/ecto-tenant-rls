defmodule Tenant.Repo do
  use Ecto.Repo,
    otp_app: :tenant,
    adapter: Ecto.Adapters.Postgres
end

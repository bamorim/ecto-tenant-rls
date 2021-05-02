defmodule Tenant.EctoStrategy do
  use ExMachina.Strategy, function_name: :insert

  def handle_insert(to_insert, %{repo: repo} = config) do
    repo.tenant_checkout("no-tenant", fn ->
      ExMachina.EctoStrategy.handle_insert(to_insert, config)
    end)
  end

  def handle_insert(to_insert, %{repo: repo} = config, opts) do
    repo.tenant_checkout("no-tenant", fn ->
      ExMachina.EctoStrategy.handle_insert(to_insert, config, opts)
    end)
  end
end

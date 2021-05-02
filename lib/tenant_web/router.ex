defmodule TenantWeb.Router do
  use TenantWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :set_tenant_id
    plug :load_tenant_id
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TenantWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/categories", CategoryController
    resources "/products", ProductController
  end

  # Other scopes may use custom stacks.
  # scope "/api", TenantWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TenantWeb.Telemetry
    end
  end

  def set_tenant_id(conn, _opts) do
    case conn.params do
      %{"tenant_id" => tenant_id} ->
        conn
        |> Plug.Conn.put_session("tenant_id", tenant_id)

      _ ->
        if is_nil(Plug.Conn.get_session(conn, "tenant_id")) do
          conn
          |> Plug.Conn.put_session("tenant_id", 1)
        else
          conn
        end
    end
  end

  def load_tenant_id(conn, _opts) do
    with %{"tenant_id" => tenant_id} <- Plug.Conn.get_session(conn) do
      Process.put(:tenant_id, tenant_id)
    end

    conn
  end
end

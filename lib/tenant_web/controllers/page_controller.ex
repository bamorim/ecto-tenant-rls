defmodule TenantWeb.PageController do
  use TenantWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

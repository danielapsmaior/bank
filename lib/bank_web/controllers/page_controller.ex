defmodule BankWeb.PageController do
  use BankWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def protected(conn, _) do
    account = Guardian.Plug.current_resource(conn)
    render(conn, "protected.html", current_account: account)
  end
end

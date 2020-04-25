defmodule BankWeb.TransactionController do
  use BankWeb, :controller

  def index(conn, params) do
    json(conn, "OK")
  end
end

defmodule BankWeb.AccountController do
  use BankWeb, :controller

  alias Bank.Domain.Account

  def create(conn, params) do
    params
    |> Account.validate()
    |> Account.create()
    |> result(conn)
  end

  defp result({:ok, account_number}, conn),
    do: json(conn, "Account #{account_number} successfully created")

  defp result({:error, error}, conn) do
    conn
    |> put_status(422)
    |> put_resp_content_type("application/json")
    |> json(error)
  end
end

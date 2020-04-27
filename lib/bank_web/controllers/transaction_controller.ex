defmodule BankWeb.TransactionController do
  use BankWeb, :controller

  alias Bank.Domain.Transaction

  def withdraw(conn, %{"amount" => amount}) do
    account = Bank.Authentication.get_account(conn)

      amount
      |> Transaction.withdrawal(account)
      |> result(conn)

  end

  defp result({:ok, account, transaction}, conn),
    do: json(conn, %{success: %{balance: transaction.balance}})

  defp result({:error, error}, conn) do
    conn
    |> put_status(422)
    |> json(%{errors: error})
  end
end

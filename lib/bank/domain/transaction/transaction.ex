defmodule Bank.Domain.Transaction do
  alias Bank.Domain.Schema.Account
  alias Bank.Domain.Schema.Transaction

  require Logger

  @repository Application.fetch_env!(:bank, :repository)

  def create({:ok, %Transaction{} = transaction}, account) do
    transaction
    |> @repository.save_transaction()
    |> response(account)
  end

  def receive({:ok, %Account{} = account}, amount) do
  	Logger.info("Transaction receive")

  	%{type: :receive, account_id: account.id, amount: amount, balance: amount}
    |> validate()
    |> create(account)
  end

  def receive({:error, _} = error, _), do: error

  defp response({:ok, %Transaction{}}, %Account{} = account), do: {:ok, account}
  defp response(_, _), do: {:error, "Error to save transaction"}

  def validate(fields) do
  	%Transaction{}
    |> Transaction.validate(fields)
    |> Bank.ValidationHandler.parse_changeset_result()
  end
end

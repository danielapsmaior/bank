defmodule Bank.Domain.Transaction do
  alias Bank.Domain.Schema.Account
  alias Bank.Domain.Schema.Transaction
  alias Bank.ValidationHandler

  require Logger

  @repository Application.fetch_env!(:bank, :repository)

  defp create({:ok, %Transaction{} = transaction}, account) do
    transaction
    |> @repository.save_transaction()
    |> response(account)
  end

  defp create({:error, _} = error, _account), do: error

  def receive({:ok, %Account{} = account}, amount) do
    %{type: :receive, account_id: account.id, amount: amount, balance: amount}
    |> validate()
    |> create(account)
  end

  def receive({:error, _} = error, _), do: error

  defp response({:ok, %Transaction{} = transaction}, %Account{} = account), do: {:ok, account, transaction}
  defp response(_, _), do: {:error, "Error to save transaction"}

  def validate(fields) do
    %Transaction{}
    |> Transaction.validate(fields)
    |> ValidationHandler.parse_result()
  end

  def withdrawal(amount, %Account{} = account) do
  	balance = @repository.get_balance(account.id)
  	%{type: :withdrawal, account_id: account.id, amount: amount, balance: balance}
    |> validate()
    |> create(account)
  end

  def transfer(%{amount: amount, account_number: account_number}, %Account{} = account) do
  	balance = @repository.get_balance(account.id)

  	%{type: :transfer, account_id: account.id, amount: amount, balance: balance}
    |> validate()
    |> create(account)
    |> create_in_other_account(amount, account_number)
    |> update_first_transaction_with_related_transaction()
    |> Tuple.insert_at(1, account)
  end

  defp create_in_other_account({:ok, _account, first_transaction}, amount, account_number) do
  	transfer_to_account = @repository.get_account_by_account_number(account_number)
  	balance = @repository.get_balance(transfer_to_account.id)

  	%{type: :receive, account_id: transfer_to_account.id, amount: amount, balance: balance, related_transaction: first_transaction.id}
    |> validate()
    |> create(transfer_to_account)
    |> Tuple.append(first_transaction)
  end

  defp update_first_transaction_with_related_transaction({:ok, _account, second_transaction, first_transaction}) do
  	first_transaction
  	|> Transaction.put_related_transaction(second_transaction.id)
  	|> @repository.update_transaction()
  end
end

defmodule Bank.Domain.Account do
  alias Bank.Domain.Transaction
  alias Bank.Domain.Schema.Account
  alias Bank.ValidationHandler

  require Logger

  @initial_amount Application.fetch_env!(:bank, :initial_amount)
  @repository Application.fetch_env!(:bank, :repository)

  def create({:ok, %Account{} = account}) do
    account
    |> create_account_number()
    |> @repository.save_account()
    |> Transaction.receive(@initial_amount)
    |> response()
  end

  def create({:error, _msg} = error), do: error

  defp create_account_number(account) do
    account |> Map.put(:account_number, Ecto.UUID.generate())
  end

  defp response({:ok, %Account{} = account, _transaction}) do
    {:ok, account.account_number}
  end

  defp response({:error, error_message}) do
    Logger.error(inspect(error_message))
    {:error, error_message}
  end

  def validate(fields) do
    %Account{}
    |> Account.validate(fields)
    |> ValidationHandler.parse_result()
  end

  def get_account!(id), do: @repository.get_account!(id)
end

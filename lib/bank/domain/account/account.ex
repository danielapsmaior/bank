defmodule Bank.Domain.Account do
  alias Bank.Domain.Transaction
  alias Bank.Domain.Schema.Account
  alias Bank.Repo

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
    Logger.info("RESPONSE OK")
    {:ok, account.account_number}
  end

  defp response({:error, error_message}) do
    Logger.error(inspect(error_message))
    {:error, error_message}
  end

  def validate(fields) do
    %Account{}
    |> Account.validate(fields)
    |> Bank.ValidationHandler.parse_changeset_result()
  end

  def list_accounts do
    Repo.all(Account)
  end

  def get_account!(id), do: Repo.get!(Account, id)

  # The tutorial calls this one:
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.validate(attrs)
    |> Repo.insert()
  end

  def update_account(%Account{} = account, attrs) do
    account
    |> Account.validate(attrs)
    |> Repo.update()
  end

  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  # The tutorial calls this one:
  def change_account(%Account{} = account) do
    Account.validate(account, %{})
  end
end

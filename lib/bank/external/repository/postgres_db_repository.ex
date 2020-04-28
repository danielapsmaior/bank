defmodule Bank.Infra.PostgresDBRepository do
  @behaviour Bank.Infra.Repository

  alias Bank.ValidationHandler
  alias Bank.Domain.Schema.Account
  alias Bank.Domain.Schema.Transaction
  alias Bank.Repo

  require Logger

  import Ecto.Query, only: [from: 2]

  @impl true
  def save_account(%Account{} = account) do
    account
    |> Account.validate()
    |> Repo.insert()
    |> parse_insert_result()
  end

  @impl true
  def save_transaction(%Transaction{} = transaction) do
    transaction
    |> Transaction.validate()
    |> Repo.insert()
    |> parse_insert_result()
  end

  defp parse_insert_result({:error, result}), do: ValidationHandler.parse_result(result)
  defp parse_insert_result({:ok, _entity} = result), do: result

  def get_balance(account_id) do
    from(t in Transaction, where: t.account_id == ^account_id, order_by: [desc: t.id], limit: 1)
    |> Repo.one()
    |> Map.get(:balance)
  end

  def get_account_by_account_number(account_number) do
    from(acc in Account, where: acc.account_number == ^account_number)
    |> Repo.one()
  end

  def update_transaction(transaction) do
    transaction
    |> Repo.update()
    |> parse_insert_result()
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
end

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

  defp parse_insert_result({:error, %Ecto.Changeset{valid?: false} = changeset}),
    do: ValidationHandler.parse_changeset_result(changeset)

  defp parse_insert_result({:ok, entity}) do
    Logger.info("PostgresDBRepository  parse_insert_result #{inspect(entity)}")

    {:ok, entity}
  end

  def get_balance(account_id) do
    from(t in Transaction, where: t.account_id == ^account_id, order_by: [desc: t.id], limit: 1)
    |> Repo.one()
    |> Map.get(:balance)
  end
end

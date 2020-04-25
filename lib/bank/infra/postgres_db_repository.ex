defmodule Bank.Infra.PostgresDBRepository do
  @behaviour Bank.Infra.Repository

  alias Bank.ValidationHandler
  alias Bank.Domain.Schema.Account
  alias Bank.Domain.Schema.Transaction
  alias Bank.Repo

  require Logger

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

  defp parse_insert_result({:error, %Ecto.Changeset{valid?: false} = result}), do:
  	{:error, ValidationHandler.convert_to_string(result.errors)}


  defp parse_insert_result({:ok,entity}) do
  	Logger.info("PostgresDBRepository  parse_insert_result #{inspect(entity)}")

  	{:ok, entity}
  end
 end

defmodule Bank.Infra.Repository do
  alias Bank.Domain.Schema.Account
  alias Bank.Domain.Schema.Transaction

  @callback save_account(%Account{}) :: {:ok, %Account{}} | {:error, String.t()}
  @callback save_transaction(%Transaction{}) :: {:ok, %Transaction{}} | {:error, String.t()}
end

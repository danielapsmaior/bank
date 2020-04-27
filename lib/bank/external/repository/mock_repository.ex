defmodule Bank.Infra.MockRepository do
  @behaviour Bank.Infra.Repository

  @impl true
  def save_account(account) do
    {:ok, account |> Map.put(:id, 1)}
  end

  @impl true
  def save_transaction(transaction) do
    {:ok, transaction |> Map.put(:id, 1)}
  end
end

defmodule Bank.Domain.Schema.TransactionType do
  use EctoEnum.Postgres, type: :transaction_type, enums: [:withdrawal, :transfer, :receive]
end

defmodule Bank.Domain.Schema.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.Domain.Schema.Account
  alias Bank.Domain.Schema.TransactionType

  schema "transactions" do
    field(:type, TransactionType)
    field(:amount, :float)
    field(:balance, :float)
    field(:related_transaction, :id, null: true)
    belongs_to :account, Account

    timestamps(type: :utc_datetime_usec)
  end

  def validate(transaction, params \\ %{}) do
    transaction
    |> cast(params, [:account_id, :type, :amount, :balance, :related_transaction])
    |> validate_required([:account_id, :type, :amount, :balance])
    |> validate_amount()
    |> put_new_balance()
  end

  defp validate_amount(%Ecto.Changeset{changes: %{type: :receive}} = changeset), do: changeset
  defp validate_amount(%Ecto.Changeset{valid?: true, changes: %{amount: amount}} = changeset) do
    change(changeset, amount: -1 * amount)
  end
  defp validate_amount(changeset), do: changeset

  defp put_new_balance(
         %Ecto.Changeset{valid?: true, changes: %{balance: balance, amount: amount}} = changeset
       ) do
    change(changeset, balance: balance + amount)
  end
  defp put_new_balance(changeset), do: changeset

  def put_related_transaction(transaction, related_transaction_id) do
    transaction |> change(related_transaction: related_transaction_id)
  end
end

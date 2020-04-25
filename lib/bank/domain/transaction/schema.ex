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
    |> cast(params, [:account_id, :type, :amount, :balance])
    |> validate_required([:account_id, :type, :amount, :balance])
  end
end



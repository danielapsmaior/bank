defmodule Bank.Model.Transaction do
  use Ecto.Schema

  import EctoEnum
  defenum(TransactionType, withdrawal: 0, transfer: 1, receive: 2)

  schema "transactions" do
    field(:type, TransactionType)
    field(:amount, :float)
    field(:balance, :float)
    field(:related_transaction, :id, null: true)
    belongs_to :account, Bank.Model.Account

    timestamps(type: :utc_datetime_usec)
  end
end

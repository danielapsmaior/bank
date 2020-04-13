defmodule Bank.Model.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field(:account_number, :string)
    field(:name, :string)
    field(:phone, :string)
    field(:email, :string)
    field(:password, :string)
    field(:cpf, :integer)
    has_many :transactions, Bank.Model.Transaction
  end

  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:account_number, :name, :email, :password, :cpf])
    |> validate_required([:account_number, :name, :email, :password, :cpf])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:cpf, 13)

    # |> unique_constraint(:account_number, :email, :cpf)
  end
end

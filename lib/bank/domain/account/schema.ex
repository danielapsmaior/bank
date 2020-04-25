defmodule Bank.Domain.Schema.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.Domain.Schema.Transaction

  schema "accounts" do
    field(:account_number, :string)
    field(:name, :string)
    field(:phone, :string)
    field(:email, :string)
    field(:password, :string)
    field(:cpf, :string)
    has_many :transactions, Transaction
  end

  def validate(account, params \\ %{}) do
    account
    |> cast(params, [:name, :email, :password, :cpf])
    |> validate_required([:name, :email, :password, :cpf])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:cpf, is: 11)
    |> unique_constraint(:account_number)
    |> unique_constraint(:email)
    |> unique_constraint(:cpf)
  end
end

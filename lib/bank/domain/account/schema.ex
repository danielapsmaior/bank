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
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end

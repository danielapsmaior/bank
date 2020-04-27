defmodule Bank.Repo.Migrations.CreateTables do
  use Ecto.Migration

  alias Bank.Domain.Schema.TransactionType

  def up do
    create table(:accounts) do
      add :account_number, :string, unique: true, null: false
      add :name, :string, null: false
      add :phone, :string
      add :email, :string, unique: true, null: false
      add :password, :string, null: false
      add :cpf, :string, size: 11, unique: true, null: false
    end

    create(unique_index(:accounts, [:account_number]))
    create(unique_index(:accounts, [:email]))
    create(unique_index(:accounts, [:cpf]))
    create(index(:accounts, [:name]))
    create(index(:accounts, [:phone]))

    TransactionType.create_type()

    create table(:transactions) do
      add :account_id, references(:accounts)
      add :type, TransactionType.type()
      add :amount, :float
      add :balance, :float
      add :related_transaction, references(:transactions), null: true

      timestamps(type: :timestamptz)
    end
  end

  def down do
    drop table(:transactions)
    drop table(:accounts)
    TransactionType.drop_type()
  end
end

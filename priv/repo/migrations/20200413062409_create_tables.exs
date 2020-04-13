defmodule Bank.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :account_number, :string, unique: true, null: false
      add :name, :string, null: false
      add :phone, :string
      add :email, :string, unique: true, null: false
      add :password, :string, null: false
      add :cpf, :integer, unique: true, null: false
    end

    create(unique_index(:accounts, [:account_number]))
    create(unique_index(:accounts, [:email]))
    create(unique_index(:accounts, [:cpf]))
    create(index(:accounts, [:name]))
    create(index(:accounts, [:phone]))

    create table(:transactions) do
      add :account_id, references(:accounts)
      add :type, :integer
      add :amount, :float
      add :balance, :float
      add :related_transaction, references(:transactions), null: true
    end
  end
end

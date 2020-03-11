defmodule GpsAlerts.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :is_active, :boolean, default: false, null: false
      add :name, :string
      add :mobile, :string
      add :client_id, references(:clients, on_delete: :nothing)
      add :last_connection, :naive_datetime
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:name])
  end
end

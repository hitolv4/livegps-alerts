defmodule GpsAlerts.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :name, :string
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

  end
end

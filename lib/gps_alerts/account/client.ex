defmodule GpsAlerts.Account.Client do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clients" do
    field :is_active, :boolean, default: false
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:name, :is_active])
    |> validate_required([:name, :is_active])
  end
end

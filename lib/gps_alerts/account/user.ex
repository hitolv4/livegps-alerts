defmodule GpsAlerts.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias GpsAlerts.Account.Client

  schema "users" do
    field :email, :string
    field :is_active, :boolean, default: false
    field :mobile, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    belongs_to :client, Client

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :is_active, :name, :mobile, :password, :client_id])
    |> validate_required([:email, :is_active, :name, :mobile, :password, :client_id])
    |> unique_constraint(:email)
    |> assoc_constraint(:client)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end

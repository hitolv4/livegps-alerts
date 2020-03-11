defmodule GpsAlerts.AccountTest do
  use GpsAlerts.DataCase

  alias GpsAlerts.Account

  describe "clients" do
    alias GpsAlerts.Account.Client

    @valid_attrs %{is_active: true, name: "some name"}
    @update_attrs %{is_active: false, name: "some updated name"}
    @invalid_attrs %{is_active: nil, name: nil}

    def client_fixture(attrs \\ %{}) do
      {:ok, client} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_client()

      client
    end

    test "list_clients/0 returns all clients" do
      client = client_fixture()
      assert Account.list_clients() == [client]
    end

    test "get_client!/1 returns the client with given id" do
      client = client_fixture()
      assert Account.get_client!(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      assert {:ok, %Client{} = client} = Account.create_client(@valid_attrs)
      assert client.is_active == true
      assert client.name == "some name"
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_client(@invalid_attrs)
    end

    test "update_client/2 with valid data updates the client" do
      client = client_fixture()
      assert {:ok, %Client{} = client} = Account.update_client(client, @update_attrs)
      assert client.is_active == false
      assert client.name == "some updated name"
    end

    test "update_client/2 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_client(client, @invalid_attrs)
      assert client == Account.get_client!(client.id)
    end

    test "delete_client/1 deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Account.delete_client(client)
      assert_raise Ecto.NoResultsError, fn -> Account.get_client!(client.id) end
    end

    test "change_client/1 returns a client changeset" do
      client = client_fixture()
      assert %Ecto.Changeset{} = Account.change_client(client)
    end
  end

  describe "users" do
    alias GpsAlerts.Account.User

    @valid_attrs %{
      email: "some email",
      is_active: true,
      mobile: "some mobile",
      name: "some name",
      password: "some password",
      client_id: 1
    }
    @update_attrs %{
      email: "some updated email",
      is_active: false,
      mobile: "some updated mobile",
      name: "some updated name",
      password: "some updated password",
      client_id: 2
    }
    @invalid_attrs %{
      email: nil,
      is_active: nil,
      mobile: nil,
      name: nil,
      password: nil,
      client_id: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, client} = Account.create_client(%{name: "some name"})

      {:ok, user} =
        attrs
        |> Map.merge(%{client_id: client.id})
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      {user, client}
    end

    def get_client_id do
      Account.list_clients() |> hd |> Map.get(:id)
    end

    test "list_users/0 returns all users" do
      {user, client} = user_fixture()
      assert Account.list_users() == [%User{user | password: nil}]
    end

    test "get_user!/1 returns the user with given id" do
      {user, client} = user_fixture()
      assert Account.get_user!(user.id) == %User{user | password: nil}
    end

    test "create_user/1 with valid data creates a user" do
      {:ok, client} = Account.create_client(%{name: "alala"})
      assert {:ok, %User{} = user} = Account.create_user(%{@valid_attrs | client_id: client.id})
      assert user.email == "some email"
      assert user.is_active == true
      assert user.mobile == "some mobile"
      assert user.name == "some name"
      assert user.client_id == client.id
      assert Bcrypt.verify_pass("some password", user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      {user, client} = user_fixture()
      client_id = get_client_id()

      assert {:ok, %User{} = user} =
               Account.update_user(user, %{@update_attrs | client_id: client_id})

      assert user.email == "some updated email"
      assert user.is_active == false
      assert user.mobile == "some updated mobile"
      assert user.name == "some updated name"
      assert Bcrypt.verify_pass("some updated password", user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      {user, client} = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert %User{user | password: nil} == Account.get_user!(user.id)
      assert Bcrypt.verify_pass("some password", user.password_hash)
    end

    test "delete_user/1 deletes the user" do
      {user, client} = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      {user, client} = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end
end

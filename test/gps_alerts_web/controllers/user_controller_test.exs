defmodule GpsAlertsWeb.UserControllerTest do
  use GpsAlertsWeb.ConnCase

  alias GpsAlerts.Account
  alias GpsAlerts.Account.User
  alias Plug.Test

  @create_attrs %{
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
    password: "some updated password"
  }

  @current_user_attrs %{
    email: "some current user email",
    name: "some current name",
    is_active: true,
    password: "some current user password",
    mobile: "123421341234",
    client_id: nil
  }

  @client_attrs %{
    name: "test"
  }
  @invalid_attrs %{email: nil, is_active: nil, mobile: nil, name: nil, password: nil}

  def fixture(:client) do
    {:ok, client} = Account.create_client(@client_attrs)
    client
  end

  def fixture(:user, client) do
    {:ok, user} = Account.create_user(%{@create_attrs | client_id: client.id})
    user
  end

  def fixture(:current_user, client) do
    {:ok, current_user} = Account.create_user(%{@current_user_attrs | client_id: client.id})
    current_user
  end

  setup %{conn: conn} do
    client = fixture(:client)
    {:ok, conn: conn, current_user: current_user} = setup_current_user(conn, client)

    {:ok,
     conn: put_req_header(conn, "accept", "application/json"),
     current_user: current_user,
     client: client}
  end

  describe "index" do
    test "lists all users", %{conn: conn, current_user: current_user} do
      conn = get(conn, Routes.user_path(conn, :index))

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => current_user.id,
                 "email" => current_user.email,
                 "is_active" => current_user.is_active,
                 "mobile" => current_user.mobile,
                 "name" => current_user.name,
                 "client_id" => current_user.client_id
               }
             ]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{
      conn: conn,
      client: client,
      current_user: _current_user
    } do
      conn =
        post(conn, Routes.user_path(conn, :create), user: %{@create_attrs | client_id: client.id})

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some email",
               "is_active" => true,
               "mobile" => "some mobile",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      # assert json_response(conn, 422)["errors"] != %{}
      assert match?(%{"errors" => _list}, json_response(conn, 422))
    end
  end

  describe "update user" do
    setup [:create_user]

    @tag update_user: "valid"
    test "renders user when data is valid", %{
      conn: conn,
      user: %User{id: id, client_id: client_id} = user
    } do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id, "client_id" => ^client_id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "is_active" => false,
               "mobile" => "some updated mobile",
               "name" => "some updated name",
               "client_id" => ^client_id
             } = json_response(conn, 200)["data"]
    end

    @tag update_user: "not valid"
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert match?(%{"errors" => _list}, json_response(conn, 422))
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(%{client: client}) do
    user = fixture(:user, client)
    {:ok, user: user}
  end

  defp setup_current_user(conn, client) do
    current_user = fixture(:current_user, client)

    {:ok,
     conn: Test.init_test_session(conn, current_user_id: current_user.id),
     current_user: current_user}
  end
end

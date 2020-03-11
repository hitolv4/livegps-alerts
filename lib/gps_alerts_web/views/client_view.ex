defmodule GpsAlertsWeb.ClientView do
  use GpsAlertsWeb, :view
  alias GpsAlertsWeb.ClientView

  def render("index.json", %{clients: clients}) do
    %{data: render_many(clients, ClientView, "client.json")}
  end

  def render("show.json", %{client: client}) do
    %{data: render_one(client, ClientView, "client.json")}
  end

  def render("client.json", %{client: client}) do
    %{id: client.id,
      name: client.name,
      is_active: client.is_active}
  end
end

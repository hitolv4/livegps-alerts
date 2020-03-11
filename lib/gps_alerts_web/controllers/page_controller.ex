defmodule GpsAlertsWeb.PageController do
  use GpsAlertsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

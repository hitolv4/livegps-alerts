defmodule GpsAlerts.Gpscon do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://socketgpsv1.gestsol.cl"

  plug Tesla.Middleware.Logger
  plug Tesla.Middleware.JSON

  require Logger

  def lpf() do
    case get("/api/lpf") do
      {:ok, %{body: msg}} ->
        {:ok, msg}

      otro ->
        Logger.warn("no se puede optener msg: #{inspect(otro)}")
        {:error, "error"}
    end
  end

  def position(lat, lon) do
    case get("https://maps.gestsol.io/nominatim/reverse.php?format=json&lat=#{lat}&lon=#{lon}") do
      {:ok, %{body: msg}} ->
        {:ok, msg}

      otro ->
        Logger.warn("no se puede optener msg: #{inspect(otro)}")
        {:error, "error"}
    end
  end
end

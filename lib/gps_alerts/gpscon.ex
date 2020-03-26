defmodule GpsAlerts.GpsCon do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://socketgpsv1.gestsol.cl"
  # @api_key System.get_env("GPS_KEY")
  @api_key "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlJrTkdORUUyTmpSQ01FRTJOVFpFUlVFNFJETXdRVUl4UkVRMU1rVXdRMFV4T1RWQk56TTBOUSJ9.eyJpc3MiOiJodHRwczovL2dlc3Rzb2wuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVkMWEyMjU2NDIxZjUyMGQyMTAxOGY1NCIsImF1ZCI6WyJodHRwczovL2dlc3Rzb2wuYXV0aDAuY29tL2FwaS92Mi8iLCJodHRwczovL2dlc3Rzb2wuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTU4NDcyNjc1MiwiZXhwIjoxNTg1NzI2NzUxLCJhenAiOiI5R1FLMGxCeVY0NFlpSXhGMWJCeDNTZFY2NktuVk0yRCIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwgcmVhZDpjdXJyZW50X3VzZXIgdXBkYXRlOmN1cnJlbnRfdXNlcl9tZXRhZGF0YSBkZWxldGU6Y3VycmVudF91c2VyX21ldGFkYXRhIGNyZWF0ZTpjdXJyZW50X3VzZXJfbWV0YWRhdGEgY3JlYXRlOmN1cnJlbnRfdXNlcl9kZXZpY2VfY3JlZGVudGlhbHMgZGVsZXRlOmN1cnJlbnRfdXNlcl9kZXZpY2VfY3JlZGVudGlhbHMgdXBkYXRlOmN1cnJlbnRfdXNlcl9pZGVudGl0aWVzIG9mZmxpbmVfYWNjZXNzIiwiZ3R5IjoicGFzc3dvcmQifQ.EtkD352s_YQNQtd3-f8vWXiXclBt6kk_ysYeLtjC0ci3qUZYjlNzFD43-EQWQz6cShOJQ7PPKe7NoZlfqqwiK1ts-SumKSW1sptnYE6ssFI-7D8bEYNtAXIA5LnXNsh2SxozcEa4w3GMGQb9spO0J0NeUXtSUqCD3zPZv7mRoCteOTOFeM6e6FQ7Jfx56mewJwz1D31xwR7vX8S6be9gvBQZXrH21Sy2MrX9tvSSJ80AG_iLtJiJAp6dQjb5_kvkGpiF90qgN-Yzari6J67ynmbtg-HnkOoLRp51AdTyU7lvWpkX1rxwukDWZwJUqvRrrQUg-lhxBGA0fyOe2bTP8A"
  plug Tesla.Middleware.Headers, [
    {"content-type", "application/json"},
    {"Authorization", @api_key}
  ]

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

  def device_by_id(id) do
    case get("/sapi/devices/#{id}") do
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

  def place(place_id) do
    case get("https://maps.gestsol.io/nominatim/details.php?format=json&place_id=#{place_id}") do
      {:ok, %{body: msg}} ->
        {:ok, msg}

      otro ->
        Logger.warn("no se puede optener msg: #{inspect(otro)}")
        {:error, "error"}
    end
  end
end

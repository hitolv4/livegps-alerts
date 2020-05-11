defmodule GpsAlerts.GpsCon do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://socketgpsv1.gestsol.cl"
  # @api_key System.get_env("GPS_KEY")
  @api_key "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlJrTkdORUUyTmpSQ01FRTJOVFpFUlVFNFJETXdRVUl4UkVRMU1rVXdRMFV4T1RWQk56TTBOUSJ9.eyJpc3MiOiJodHRwczovL2dlc3Rzb2wuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVkMWEyMjU2NDIxZjUyMGQyMTAxOGY1NCIsImF1ZCI6WyJodHRwczovL2dlc3Rzb2wuYXV0aDAuY29tL2FwaS92Mi8iLCJodHRwczovL2dlc3Rzb2wuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTU4NTc1NDE0MCwiZXhwIjoxNTg2NzU0MTM5LCJhenAiOiI5R1FLMGxCeVY0NFlpSXhGMWJCeDNTZFY2NktuVk0yRCIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwgcmVhZDpjdXJyZW50X3VzZXIgdXBkYXRlOmN1cnJlbnRfdXNlcl9tZXRhZGF0YSBkZWxldGU6Y3VycmVudF91c2VyX21ldGFkYXRhIGNyZWF0ZTpjdXJyZW50X3VzZXJfbWV0YWRhdGEgY3JlYXRlOmN1cnJlbnRfdXNlcl9kZXZpY2VfY3JlZGVudGlhbHMgZGVsZXRlOmN1cnJlbnRfdXNlcl9kZXZpY2VfY3JlZGVudGlhbHMgdXBkYXRlOmN1cnJlbnRfdXNlcl9pZGVudGl0aWVzIG9mZmxpbmVfYWNjZXNzIiwiZ3R5IjoicGFzc3dvcmQifQ.cBxn7v5NcLWZ9LVdgZzGrzaLhhXRkm6-Xu1oY94xFmRpCcz3bppkKT3JolKeKDIx-aIJiQuIZFaeapwAq964oArVMnGYPtQxlW-dPGZ519jkzoQqKHMmzj0x3vmwzgTwA_0jPLeSpcY682wIfyRHz4fC3A9RKTcr_9eA9B6xqFoUxe7fPI2EQ06PN8ppD_FVWA8uTwJ7e9c1Q2HPthwWMKLXBJ0YYCvyRMLnqAW0S5Sf1CEGc28fXmnfCLd7bTlQtlXTMqcR-LwnXWzqtx9Bnrh0UHgz0hq88I1BC7H0CCu-WqrlHlHJS0nfhH-Y2FAUFlrgKGnE_Ibc-yEMnALK_w"
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

defmodule GpsAlerts.GpsCon do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://socketgpsv1.gestsol.cl"
  # @api_key System.get_env("GPS_KEY")
  @api_key "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlJrTkdORUUyTmpSQ01FRTJOVFpFUlVFNFJETXdRVUl4UkVRMU1rVXdRMFV4T1RWQk56TTBOUSJ9.eyJpc3MiOiJodHRwczovL2dlc3Rzb2wuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVkZmJjOGE3ZjZhYjU0MGYxNjRlODQ2MiIsImF1ZCI6WyJodHRwczovL2dlc3Rzb2wuYXV0aDAuY29tL2FwaS92Mi8iLCJodHRwczovL2dlc3Rzb2wuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTU4OTgxMDkzNywiZXhwIjoxNTkwODEwOTM2LCJhenAiOiI5R1FLMGxCeVY0NFlpSXhGMWJCeDNTZFY2NktuVk0yRCIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwgcmVhZDpjdXJyZW50X3VzZXIgdXBkYXRlOmN1cnJlbnRfdXNlcl9tZXRhZGF0YSBkZWxldGU6Y3VycmVudF91c2VyX21ldGFkYXRhIGNyZWF0ZTpjdXJyZW50X3VzZXJfbWV0YWRhdGEgY3JlYXRlOmN1cnJlbnRfdXNlcl9kZXZpY2VfY3JlZGVudGlhbHMgZGVsZXRlOmN1cnJlbnRfdXNlcl9kZXZpY2VfY3JlZGVudGlhbHMgdXBkYXRlOmN1cnJlbnRfdXNlcl9pZGVudGl0aWVzIG9mZmxpbmVfYWNjZXNzIiwiZ3R5IjoicGFzc3dvcmQifQ.C_moCCCeAbnk6UX33uCQYor_XBjAG05XJk7hIw77DplxAIiGx7hMltLWngypDh14TeCUqWms_1Y4MQoSzEipA4SsKG2Rag_HmZZGqtDnUXi1iUiUWTvqABZrcz4Q5DysCS2D833mBODa77GYFC3ZyuOIvZ5qTc3wPuD0p9xCElggOMZ6-b5ZXPR_PiEo7a3SADQGXkfmtQT-CzVm5IGAsHpc5yaWMzVuVJ_l6TGkS6Ygyr5C9e0aRakI_l1iXWqqMLToLFjLGxJLlrqmo_qZfLkf407VGUR0oZbAWqI2tJKgGCu6EIb2m1xOgkO5GJ9RpeXbLM7r75MNGIYs_98m0g"
  plug Tesla.Middleware.Headers, [
    {"content-type", "application/json"},
    {"Authorization", @api_key}
  ]

  plug Tesla.Middleware.Logger

  plug Tesla.Middleware.JSON

  require Logger

  def authenticate do
    IO.puts("authenticate")
  end

  def auth_params do
    %{
      params: Application.get_env(:gps_alerts, GpsAlerts.GpsCon)[:credentials]
    }
  end

  def headers do
    [{"content-type", "application/json"}]
  end

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

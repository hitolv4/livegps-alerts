defmodule GpsAlerts.Wassenger do
  use Tesla

  @api_key System.get_env("WASSENGER_KEY")

  plug Tesla.Middleware.BaseUrl, "https://api.wassi.chat/v1"

  plug Tesla.Middleware.Headers, [
    {"Authorization", @api_key},
    {"content-type", "application/json"}
  ]

  plug Tesla.Middleware.Logger
  plug Tesla.Middleware.JSON

  require Logger

  def send_text(phone, text) do
    case post("/messages", %{phone: "+" <> phone, message: text}) do
      {:ok, %{status: 201}} ->
        {:ok, phone}

      {:ok, %{body: %{message: msg}}} ->
        {:error, msg}

      otro ->
        Logger.warn("No se puede enviar msg: #{inspect(otro)}")
        {:error, "error"}
    end
  end
end

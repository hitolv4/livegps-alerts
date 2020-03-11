defmodule GpsAlerts.Repo do
  use Ecto.Repo,
    otp_app: :gps_alerts,
    adapter: Ecto.Adapters.Postgres
end

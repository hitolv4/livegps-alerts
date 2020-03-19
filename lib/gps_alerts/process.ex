defmodule GpsAlerts.Process do
  alias GpsAlerts.GpsCon

  alias GpsAlerts.Wassenger

  def init() do
    check_lpf()
    |> set_struct
    |> get_position
    |> send_message
  end

  # Para Produccion GpsCon.lpf()
  # data para ambiente de desarrollo data.json
  def check_lpf() do
    case File.read("/home/hitokiri/gestsol/gps-alerts/lib/gps_alerts/data.json") do
      {:ok, content} ->
        content
        |> Jason.decode!()
        |> Enum.filter(fn map -> map["velocity"] >= 103 end)

      {:error, reason} ->
        "error en json #{inspect(reason)}"
    end
  end

  def get_position(list) do
    Enum.map(list, fn x ->
      case GpsCon.position(x.lat, x.lng) do
        {:ok, content} ->
          %{"place_id" => place_id} = content

          case GpsCon.place(place_id) do
            {:ok, content} ->
              %{"localname" => localname} = content
              %Process.Message{x | local_name: localname}
          end

        {:error, reason} ->
          "error en place_id #{inspect(reason)}"
      end
    end)
  end

  def send_message(list) do
    Enum.map(list, fn x ->
      msg = "el vehiculo #{x.name} esta a #{x.velocity} Km/h en #{x.local_name}
        https://www.google.com/maps/place/#{x.lat},#{x.lng}"
      Wassenger.send_text("+584128892862", msg)
    end)
  end

  def set_struct(list) do
    Enum.map(list, fn x ->
      %{"name" => name, "velocity" => velocity, "lat" => lat, "lng" => lng} = x
      %Process.Message{name: name, velocity: velocity, lat: lat, lng: lng}
    end)
  end
end

defmodule GpsAlerts.Process do
  alias GpsAlerts.GpsCon

  alias GpsAlerts.Wassenger

  def init(map) do
    check_lpf(map)
    |> set_struct
    |> get_name
    |> get_position
    |> send_message
  end

  # Para Produccion GpsCon.lpf()
  # data para ambiente de desarrollo data.json
  def check_lpf(map) do
    if map["velocity"] >= 103 do
      map
    end
  end

  def get_name(map) do
    case GpsCon.device_by_id(map.device_id) do
      {:ok, content} ->
        device = Map.get(content, "data")
        %{"name" => name} = device
        %Process.Message{map | name: name}

      {:error, reason} ->
        "error opteniendo id #{reason}"
    end
  end

  def get_position(map) do
    case GpsCon.position(map.lat, map.lng) do
      {:ok, content} ->
        %{"place_id" => place_id} = content

        case GpsCon.place(place_id) do
          {:ok, content} ->
            %{"localname" => localname} = content
            %Process.Message{map | local_name: localname}
        end

      {:error, reason} ->
        "error en place_id #{inspect(reason)}"
    end
  end

  def send_message(map) do
    msg = "el vehiculo #{map.name} esta a #{map.velocity} Km/h en #{map.local_name}
        https://www.google.com/maps/place/#{map.lat},#{map.lng}"
    IO.puts("#{msg}")
    Wassenger.send_text("+584128892862", msg)
  end

  def set_struct(map) do
    %{"device_id" => device_id, "velocity" => velocity, "lat" => lat, "lng" => lng} = map
    %Process.Message{device_id: device_id, velocity: velocity, lat: lat, lng: lng}
  end
end

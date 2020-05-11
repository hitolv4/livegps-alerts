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
    if map["velocity"] >= 60 do
      map
    end
  end

  def get_name(map) do
    case GpsCon.device_by_id(map.device_id) do
      {:ok, content} ->
        device = Map.get(content, "data")
        %{"name" => name} = device
        company = Map.get(device, "group")
        %{"name" => company_name, "company_id" => company_id} = company
        %Process.Message{map | company: company_name, company_id: company_id, name: name}

      {:error, reason} ->
        "error opteniendo id #{reason}"
    end
  end

  @spec get_position(atom | %{lat: any, lng: any}) :: <<_::64, _::_*8>> | Process.Message.t()
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
    msg = "Vehiculo #{map.name} de la de la compañía #{map.company}
      va conduciendo a #{map.velocity} Km/h en #{map.local_name}
      https://www.google.com/maps/place/#{map.lat},#{map.lng}"

    IO.puts("#{msg}")
    # save_struct(map)
    save_company(map)
    # Wassenger.send_text("", msg)
    # Wassenger.send_text("", msg)
  end

  def save_company(map) do
    company = Jason.encode!(%{company_id: map.company_id})

    case File.exists?("lib/gps_alerts/pending/company.json") do
      true ->
        file = Jason.encode!(File.read!("lib/gps_alerts/pending/company.json"))

        case Enum.member?(file, Jason.decode!(company)) do
          true ->
            IO.puts("registrado")

          false ->
            IO.puts("no esta registrado")
        end

      false ->
        File.write!("lib/gps_alerts/pending/company.json", "[#{company}]")
    end
  end

  def save_struct(map) do
    line = Jason.encode!(Map.from_struct(map))
    create_or_update(line)
  end

  def create_or_update(string) do
    case File.exists?("lib/gps_alerts/pending/pending.json") do
      true ->
        file = File.read!("lib/gps_alerts/pending/pending.json")
        edit = String.replace(file, "]", "")
        File.write("lib/gps_alerts/pending/pending.json", edit)
        File.write("lib/gps_alerts/pending/pending.json", ",#{string}]", [:append])

      false ->
        File.write("lib/gps_alerts/pending/pending.json", "[#{string}]")
    end
  end

  def processing_to_send() do
    dir = File.ls!("lib/gps_alerts/pending")

    if length(dir) > 0 do
      Enum.map(dir, fn x ->
        d = Date.utc_today()
        t = Time.utc_now()
        add = "#{d.day}#{d.month}#{d.year}#{t.hour}#{t.minute}#{t.second}"

        File.rename(
          "lib/gps_alerts/pending/#{x}",
          "lib/gps_alerts/processing/pending#{add}.json"
        )

        {:ok}
      end)

      {:ok}
    end

    IO.puts("moved")
  end

  def set_struct(map) do
    %{"device_id" => device_id, "velocity" => velocity, "lat" => lat, "lng" => lng} = map
    %Process.Message{device_id: device_id, velocity: velocity, lat: lat, lng: lng}
  end
end

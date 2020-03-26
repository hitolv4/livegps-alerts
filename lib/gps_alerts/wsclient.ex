defmodule GpsAlerts.WsClient do
  use WebSockex
  alias GpsAlerts.Process

  @url "wss://socketgpsv1.gestsol.cl/socket/websocket?vsn=1.0.0"

  def start_link([]) do
    {:ok, pid} = WebSockex.start_link(@url, __MODULE__, :no_state)
    subscribe(pid)
    {:ok, pid}
  end

  def handle_connect(state) do
    IO.puts("Connected!")
    {:ok, state}
  end

  def handle_disconnect(_conn, state) do
    IO.puts("disconnected")
    {:ok, state}
  end

  def handle_frame({:text, content}, state) do
    handle_msg(Jason.decode!(content), state)

    {:ok, state}
  end

  def handle_msg(msg, state) do
    case msg do
      %{"event" => "new_position"} = newpos ->
        payload = Map.get(newpos, "payload")

        if payload["velocity"] >= 60 do
          new = payload
          %{"device_id" => device_id, "velocity" => velocity, "lat" => lat, "lng" => lng} = new

          process = %{
            "device_id" => device_id,
            "velocity" => velocity,
            "lat" => lat,
            "lng" => lng
          }

          Process.init(process)
        end

      _ ->
        :ignore
    end

    {:ok, state}
  end

  def subscribe(pid) do
    WebSockex.send_frame(pid, subscribtion_frame())
  end

  defp subscribtion_frame() do
    subscription_msg =
      %{
        topic: "devices:all",
        event: "phx_join",
        payload: %{
          idToken:
            "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlJrTkdORUUyTmpSQ01FRTJOVFpFUlVFNFJETXdRVUl4UkVRMU1rVXdRMFV4T1RWQk56TTBOUSJ9.eyJhcHBfbWV0YWRhdGEiOnsiYWRtaW4iOnRydWUsImNvbXBhbnlfYWRtaW4iOnRydWUsImNvbXBhbnlfaWQiOjM0LCJhdXRob3JpemF0aW9uIjp7InJvbGVzIjpbXX0sImNpZHMiOls4LDksMTEsMTIsMTMsMTQsMTUsMTYsMTcsMTgsMjMsMjQsMjUsMjYsMjcsMjgsMjksMzAsMzEsMzIsMzMsMzQsMzUsMzYsMzcsMzgsMzksNDEsNDQsNDcsNDgsNTYsNTAsNTEsNTUsNTYsNTcsNTksNjEsNjIsNjQsNDIsNjYsNjcsNjMsNjVdLCJncm91cHNPcHRpb24iOnRydWV9LCJ1c2VyX21ldGFkYXRhIjp7ImdyaWQiOlt7ImgiOjcsImkiOiIyIiwidyI6MTAwLCJ4IjoxLCJ5IjowfSx7ImgiOjE2LCJpIjoiMyIsInciOjE1LCJ4IjowLCJ5IjoyfSx7ImgiOjE2LCJpIjoiNCIsInciOjE1LCJ4IjoxNSwieSI6Mn0seyJoIjoxNiwiaSI6IjUiLCJ3IjoxNSwieCI6MzAsInkiOjJ9LHsiaCI6MTYsImkiOiI3IiwidyI6MTUsIngiOjQ1LCJ5IjoyfV19LCJuaWNrbmFtZSI6Im9wZXJhY2lvbmVzIiwibmFtZSI6Im9wZXJhY2lvbmVzQGdlc3Rzb2wuY2wiLCJwaWN0dXJlIjoiaHR0cHM6Ly9zLmdyYXZhdGFyLmNvbS9hdmF0YXIvMDg2YmY3NDExYjZiMTFjOGIzNDdjZTgxNTg4M2EzMjg_cz00ODAmcj1wZyZkPWh0dHBzJTNBJTJGJTJGY2RuLmF1dGgwLmNvbSUyRmF2YXRhcnMlMkZvcC5wbmciLCJ1cGRhdGVkX2F0IjoiMjAyMC0wMy0yNFQxOToyNjozOC4xNDNaIiwiZW1haWwiOiJvcGVyYWNpb25lc0BnZXN0c29sLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImlzcyI6Imh0dHBzOi8vZ2VzdHNvbC5hdXRoMC5jb20vIiwic3ViIjoiYXV0aDB8NWQxYTIyNTY0MjFmNTIwZDIxMDE4ZjU0IiwiYXVkIjoiMlIwM0kwN1V3YlV1dGh3UXZqMzR4eFJyeHhReU5pQzMiLCJpYXQiOjE1ODUwNzc5OTgsImV4cCI6MjU4NTA3Nzk5NywiYXRfaGFzaCI6IlVZOVRYam4zV2JpQnhrRnFGUGJlNEEiLCJub25jZSI6InRSUDJZQzE4ZEFqcGJEQndsM256Um5qLXBubFE0VGVGIn0.LcAHhu31jY32imUgo-eAwlBGQ_HoLPPusbTfz3cVm9jYeg5J1JfZva1Q68lENP4fg4j4_IAaxDgoxjV28EEoQ3zV3ivr-gqa3qvy_gnSc0GjpIBL8SE7TBLAno_QGyKN332l1Fwll7ImFzo4NTLvB6jyB0VuR7DkuwOYH08SyHFbOFKStMvKAI4uBzxrnHq63H2Qcrb0BTaNphMTxudm2Myp3XSb_Kb8Y35Km97JXnbzmXIO01BBKx3ehpEcsgTWiT8gzE1kuAYK9TeYPvD4Wp4Oadb3-If-rWhBhR6aCymutlD13KypR9iACuStK_f-19FJwyRQJzeIpzC1VYuHZg",
          email: "operaciones@gestsol.cl",
          company_id: 0,
          role_id: 1,
          positioning: 1
        },
        ref: nil
      }
      |> Jason.encode!()

    {:text, subscription_msg}
  end
end

defmodule GpsAlerts.Email do
  import Bamboo.Email

  def send__mail(user, msg) do
    new(user)
    |> subject("Excesos de velocidad")
    |> text_body(msg)
  end

  def new(user) do
    new_email(user)
    |> to(user)
    |> from("soporte@gestsol.cl")
  end
end

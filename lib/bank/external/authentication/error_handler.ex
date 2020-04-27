defmodule Bank.Authentication.ErrorHandler do
  import Plug.Conn
  require Logger

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, opts) do
  	Logger.error("ErrorHandler #{inspect(type)} #{inspect(reason)} #{inspect(opts)}")
    body = to_string(type)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, body)
  end
end

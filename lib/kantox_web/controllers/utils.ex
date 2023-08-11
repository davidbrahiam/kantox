defmodule KantoxWeb.Controllers.Utils do
  @moduledoc false

  def handle_response(conn, status, resp) do
    conn
    |> Plug.Conn.put_status(status)
    |> send_response(resp)
  end

  defp send_response(conn, response) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json")
    |> Plug.Conn.send_resp(conn.status, Phoenix.json_library().encode_to_iodata!(response))
  end
end

defmodule MvpVendingApi.ErrorHandler do
  @moduledoc false

  import Plug.Conn
  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, _opts) do
    body = inspect({type, reason})
    send_resp(conn, 401, body)
  end
end

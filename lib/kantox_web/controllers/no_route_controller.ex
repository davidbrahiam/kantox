defmodule KantoxWeb.Controllers.NoRouteController do
  @moduledoc false
  use KantoxWeb, :controller

  def index(conn, _params) do
    handle_response(conn, :bad_request, "Bad Request")
  end
end

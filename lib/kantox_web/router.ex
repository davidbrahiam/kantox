defmodule KantoxWeb.Router do
  use KantoxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :json_content_type do
    plug :validate_content_type, ["application/json"]
  end

  # Other scopes may use custom stacks.
  scope "/", KantoxWeb.Controllers do
    pipe_through :api

    scope "/products" do
      get "/list", ProductsController, :index

      scope "/upsert" do
        pipe_through :json_content_type
        put "/", ProductsController, :upsert
      end

      scope "/purchase" do
        pipe_through :json_content_type

        post "/", ProductsController, :purchase
      end
    end

    get "/*path", NoRouteController, :index
    post "/*path", NoRouteController, :index
    put "/*path", NoRouteController, :index
    patch "/*path", NoRouteController, :index
    delete "/*path", NoRouteController, :index
  end

  defp validate_content_type(conn, expected_content_types) do
    content =
      conn
      |> get_req_header("content-type")
      |> List.first()

    if content in expected_content_types do
      conn
    else
      conn
      |> KantoxWeb.Controllers.Utils.handle_response(400, "Bad Request")
      |> Plug.Conn.halt()
    end
  end
end

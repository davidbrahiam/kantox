defmodule KantoxWeb.Controllers.ProductsController do
  use KantoxWeb, :controller
  require Logger

  def index(conn, _params) do
    {status, response} = KantoxWeb.Services.Products.List.list()
    handle_response(conn, status, response)
  end

  @purchase_schema %{
    basket: [type: {:array, :string}, required: true]
  }
  def purchase(conn, params) do
    {status, response} =
      case Tarams.cast(params, @purchase_schema) do
        {:ok, _} ->
          # TODO:  Add service logic here

          {:ok, %{total: 0}}

        {:error, error} ->
          Logger.error("#{inspect(error)}")
          {:bad_request, "Bad Request"}
      end

    handle_response(conn, status, response)
  end

  def upsert(conn, params) do
    {status, response} =
      case Kantox.Models.Product.build(params) do
        {:ok, params} ->
          KantoxWeb.Services.Products.Upsert.upsert(params)

        {:error, error} ->
          Logger.error("#{inspect(error)}")
          {:bad_request, "Bad Request"}
      end

    handle_response(conn, status, response)
  end
end

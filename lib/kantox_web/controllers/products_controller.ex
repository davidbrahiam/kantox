defmodule KantoxWeb.Controllers.ProductsController do
  use KantoxWeb, :controller
  require Logger

  def index(conn, _params) do
    {status, response} = KantoxWeb.Services.Products.List.list()
    handle_response(conn, status, response)
  end

  def purchase(conn, params) do
    {status, response} =
      case KantoxWeb.Controllers.Requests.Products.Purchase.build(params) do
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
      case KantoxWeb.Controllers.Requests.Products.Upsert.build(params) do
        {:ok, params} ->
          promotion =
            case params.promotion do
              nil ->
                nil

              promotion ->
                %{
                  discount: Decimal.to_string(promotion.discount),
                  condition: Atom.to_string(promotion.condition),
                  elements: promotion.elements
                }
            end

          # TODO:  Add service logic here
          params = %{
            id: params.id,
            name: params.name,
            price: Decimal.to_string(params.price),
            promotion: promotion
          }

          {:ok, params}

        {:error, error} ->
          Logger.error("#{inspect(error)}")
          {:bad_request, "Bad Request"}
      end

    handle_response(conn, status, response)
  end
end

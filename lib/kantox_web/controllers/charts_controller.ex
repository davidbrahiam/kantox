defmodule KantoxWeb.Controllers.ChartsController do
  use KantoxWeb, :controller
  require Logger

  @basket_schema %{
    chart_id: [type: :string, required: true]
  }
  def basket(conn, params) do
    {status, response} =
      with {:ok, %{chart_id: chart_id}} <- Tarams.cast(params, @basket_schema),
           {:ok, worker_id} <- Kantox.Utils.validate_chart_id(chart_id) do
        KantoxWeb.Services.Charts.Basket.basket(%{chart_id: worker_id})
      else
        {:error, error} ->
          Logger.error("#{inspect(error)}")
          {:bad_request, "Bad Request"}
      end

    handle_response(conn, status, response)
  end

  @total_price_schema %{
    chart_id: [type: :string, required: true]
  }
  def total_price(conn, params) do
    {status, response} =
      with {:ok, %{chart_id: chart_id}} <- Tarams.cast(params, @total_price_schema),
           {:ok, worker_id} <- Kantox.Utils.validate_chart_id(chart_id) do
        KantoxWeb.Services.Charts.TotalPrice.total_price(%{chart_id: worker_id})
      else
        {:error, error} ->
          Logger.error("#{inspect(error)}")
          {:bad_request, "Bad Request"}
      end

    handle_response(conn, status, response)
  end

  @add_product_schema %{
    chart_id: [type: :string, required: true],
    product_id: [type: :string, required: true]
  }
  def add_product(conn, params) do
    {status, response} =
      with {:ok, %{chart_id: chart_id} = params} <- Tarams.cast(params, @add_product_schema),
           {:ok, worker_id} <- Kantox.Utils.validate_chart_id(chart_id) do
        request = Map.put(params, :chart_id, worker_id)
        KantoxWeb.Services.Charts.AddProduct.add_product(request)
      else
        {:error, error} ->
          Logger.error("#{inspect(error)}")
          {:bad_request, "Bad Request"}
      end

    handle_response(conn, status, response)
  end

  @remove_product_schema %{
    chart_id: [type: :string, required: true],
    product_id: [type: :string, required: true],
    amount: [type: :integer, required: true, default: 1]
  }
  def remove_product(conn, params) do
    {status, response} =
      with {:ok, %{chart_id: chart_id} = params} <- Tarams.cast(params, @remove_product_schema),
           {:ok, worker_id} <- Kantox.Utils.validate_chart_id(chart_id) do
        request = Map.put(params, :chart_id, worker_id)
        KantoxWeb.Services.Charts.RemoveProduct.remove_product(request)
      else
        {:error, error} ->
          Logger.error("#{inspect(error)}")
          {:bad_request, "Bad Request"}
      end

    handle_response(conn, status, response)
  end
end

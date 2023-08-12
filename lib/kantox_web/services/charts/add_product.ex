defmodule KantoxWeb.Services.Charts.AddProduct do
  @moduledoc false

  def add_product(%{chart_id: chart_id, product_id: product_id}) do
    case Kantox.Store.get_by_id(product_id) do
      nil ->
        {:not_found, "The Product doesn't exist"}

      _ ->
        list = Kantox.Chart.Worker.add_product(chart_id, product_id)

        {:ok, list}
    end
  end
end

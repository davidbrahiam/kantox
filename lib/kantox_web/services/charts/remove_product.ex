defmodule KantoxWeb.Services.Charts.RemoveProduct do
  @moduledoc false

  def remove_product(%{chart_id: chart_id} = params) do
    basket = Kantox.Chart.Worker.remove_product(chart_id, Map.delete(params, :chart_id))
    {:ok, basket}
  end
end

defmodule KantoxWeb.Services.Charts.Basket do
  @moduledoc false

  def basket(%{chart_id: id}) do
    {:ok, Kantox.Chart.Worker.basket_list(id)}
  end
end

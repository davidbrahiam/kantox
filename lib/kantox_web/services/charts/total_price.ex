defmodule KantoxWeb.Services.Charts.TotalPrice do
  @moduledoc false

  def total_price(%{chart_id: chart_id}) do
    basket = Kantox.Chart.Worker.basket_list(chart_id)

    KantoxWeb.Services.Products.Purchase.purchase(basket)
  end
end

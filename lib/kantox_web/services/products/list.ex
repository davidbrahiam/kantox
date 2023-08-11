defmodule KantoxWeb.Services.Products.List do
  @moduledoc false


  def list() do
    products =
    :persistent_term.get(:products_table)
    |> Kantox.Store.all()
    |> Enum.reduce([], fn {_k, product}, acc->
      product = KantoxWeb.Services.Products.Utils.format_product(product)
      [product | acc]
    end)
    |> Enum.reverse()

    {:ok, products}
  end
end

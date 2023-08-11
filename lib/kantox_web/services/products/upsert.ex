defmodule KantoxWeb.Services.Products.Upsert do
  @moduledoc false

  require Logger

  def upsert(%{id: product_id} = product) do
    :ok = Kantox.Store.insert({product_id, product})
    {:ok, KantoxWeb.Services.Products.Utils.format_product(product)}
  end
end

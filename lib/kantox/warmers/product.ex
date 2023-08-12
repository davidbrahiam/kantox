defmodule Kantox.Warmers.Product do
  @moduledoc """
  Initializes the state of the application by inserting the
  list of products available to purshcase in the system.
  """

  use Kantox.Warmer

  require Logger

  # It's executed only during the application's initialization
  def execute() do
    Logger.info("EXECUTING PRODUCT WARMER..")

    [
      %{
        id: "GR1",
        name: "Green tea",
        price: 3.11,
        promotion: %{condition: "get_elements_pay_discount", discount: 1, elements: 2}
      },
      %{
        id: "SR1",
        name: "Strawberries",
        price: 5.00,
        promotion: %{condition: "greater_than", discount: 0.5, elements: 3}
      },
      %{
        id: "CF1",
        name: "Coffee",
        price: 11.23,
        promotion: %{condition: "greater_than", discount: 3.7436, elements: 3}
      }
    ]
    |> Enum.each(fn product ->
      {:ok, %{id: id} = product} = Kantox.Models.Product.build(product)
      :ok = Kantox.Store.insert({id, product})
    end)

    Logger.info("PRODUCT WARMER EXECUTED !!")
    :ok
  end
end

defmodule Kantox.Warmers.Product do
  @moduledoc """
  Initializes the state of the application by inserting the
  list of products available to purshcase in the system.
  """

  use Kantox.Warmer

  require Logger

  @table :products

  # It's executed only during the application's initialization
  def execute() do
    Logger.info("EXECUTING PRODUCT WARMER..")

    [
      {"GR1",
       %{
         id: "GR1",
         name: "Green tea",
         price: 3.11,
         promotion: %{condition: :equals_to, discount: 1.555, elements: 2}
       }},
      {"SR1",
       %{
         id: "SR1",
         name: "Strawberries",
         price: 5.00,
         promotion: %{condition: :greather_than, discount: 0.5, elements: 3}
       }},
      {"CF1",
       %{
         id: "CF1",
         name: "Coffee",
         price: 11.23,
         promotion: %{condition: :greather_than, discount: 7.4867, elements: 3}
       }}
    ]
    |> Enum.each(&(:ok = Kantox.Store.insert(@table, &1)))

    Logger.info("PRODUCT WARMER EXECUTED !!")
    :ok
  end
end

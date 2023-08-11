defmodule KantoxWeb.Services.Products.Purchase do
  @moduledoc """
  Module in charge to calculate and apply promotions given a list of items

  Let's suppouse we have the following data in our system
  | Product code |    Name      | Price | Promotion                                   |
  | GR1          | Green tea    | 3.11  | Buy 1 get one free                          |
  | SR1          | Strawberries | 5.00  | If you buy 3 or more strawberries, the price should drop to £4.50
  per strawberry. |
  | CF1          | Coffee       | 11.23 | If you buy 3 or more coffees, the price of all coffees should drop
  to two thirds of the original price. |

  So if we try to purchase some products this is what we will have:

  ## Examples

  iex> :ok = Kantox.Warmers.Product.execute()
  iex> KantoxWeb.Services.Products.Purchase.purchase(%{basket: ["GR1","SR1","GR1","GR1","CF1"]})
  {:ok, %{total: "22.45"}}


  iex> :ok = Kantox.Warmers.Product.execute()
  iex> KantoxWeb.Services.Products.Purchase.purchase(%{basket: ["GR1","GR1"]})
  {:ok, %{total: "3.11"}}


  iex> :ok = Kantox.Warmers.Product.execute()
  iex> KantoxWeb.Services.Products.Purchase.purchase(%{basket: ["SR1","SR1","GR1","SR1"]})
  {:ok, %{total: "16.61"}}

  iex> :ok = Kantox.Warmers.Product.execute()
  iex> KantoxWeb.Services.Products.Purchase.purchase(%{basket: ["GR1","CF1","SR1","CF1","CF1"]})
  {:ok, %{total: "30.57"}}
  """

  def purchase(%{basket: list}) do
    list
    |> Enum.group_by(& &1)
    |> Enum.reduce_while({:ok, Decimal.new("0")}, fn {k, v}, {:ok, acc} ->
      case Kantox.Store.get_by_id(k) do
        nil ->
          {:halt, {:not_found, "Invalid products in the basket's list"}}

        %{price: price, promotion: nil} ->
          total_elements = Enum.count(v)

          bill = Decimal.mult(price, total_elements)

          {:cont, {:ok, Decimal.add(acc, bill)}}

        %{price: price, promotion: promotion} ->
          total_elements = Enum.count(v)
          bill = calculate_price_with_promotion(promotion, price, total_elements)

          {:cont, {:ok, Decimal.add(acc, bill)}}
      end
    end)
    |> case do
      {:ok, total} ->
        total_price =
          total
          |> Decimal.round(2)
          |> Kantox.Utils.decimal_to_string()

        {:ok, %{total: total_price}}

      error ->
        error
    end
  end

  defp check_condition(amount, elements, individual_price, fun) do
    cond do
      amount < elements ->
        Decimal.mult(amount, individual_price)

      amount >= elements ->
        fun.()
    end
  end

  defp calculate_price_with_promotion(
         %{condition: :equal_to, elements: elements, discount: individual_discount},
         individual_price,
         amount
       ) do
    fun = fn ->
      amount
      |> Decimal.rem(elements)
      |> Decimal.to_integer()
      |> case do
        0 ->
          to_pay = Decimal.sub(individual_price, individual_discount)
          Decimal.mult(amount, to_pay)

        k ->
          discounts = Decimal.sub(individual_price, individual_discount)
          Decimal.mult(amount + k, discounts)
      end
    end

    check_condition(amount, elements, individual_price, fun)
  end

  defp calculate_price_with_promotion(
         %{condition: :greater_than, elements: elements, discount: individual_discount},
         individual_price,
         amount
       ) do
    fun = fn ->
      to_pay = Decimal.sub(individual_price, individual_discount)
      Decimal.mult(amount, to_pay)
    end

    check_condition(amount, elements, individual_price, fun)
  end

  defp calculate_price_with_promotion(_, price, _) do
    price
  end
end

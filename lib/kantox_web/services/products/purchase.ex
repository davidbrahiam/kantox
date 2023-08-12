defmodule KantoxWeb.Services.Products.Purchase do
  @moduledoc """
  Module in charge to calculate and apply promotions given a list of items

  Let's suppouse we have the following data in our system
  | Product code |    Name      | Price | Promotion                                   |
  | GR1          | Green tea    | 3.11  | Buy 1 get one free                          |
  | SR1          | Strawberries | 5.00  | If you buy 3 or more strawberries, the price should drop to 4.50
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
         %{condition: :get_elements_pay_discount, elements: elements, discount: amount_to_pay},
         individual_price,
         amount
       ) do
    fun = fn ->
      amount
      |> Decimal.rem(elements)
      |> Decimal.to_integer()
      |> case do
        0 ->
          # In case the amount and the elements are dividable from each other
          # We just take the indivual_price and multply for the groups of elements applying the discount

          # Example:
          # Attempting to buy [GR1, GR1, GR1, GR1] when the promotion for GR1 is buy 1 get one
          # (discount = 1), this means that the `elements` to be granted to such promotion is `2`

          # So we will have the following, individual_price: 3.11, amount: 4, elements: 2, discount: 1
          # total = (amount/elements) * discount * individual_price
          # total = (4/2) * 1 * 3.11
          # total = 6.22

          pairs_of_element_present_in_amount = Decimal.div(amount, elements)

          amount_to_pay_per_pair = Decimal.mult(pairs_of_element_present_in_amount, amount_to_pay)

          Decimal.mult(individual_price, amount_to_pay_per_pair)

        remainder ->
          # In case the amount and the elements are not dividable from each other
          # We take the amount that IT IS dividable ignoring the remainder and aplying the promotion
          # Then we add the reminder without the promotion

          # Example:
          # Attempting to buy [GR1, GR1, GR1] when the promotion for GR1 is buy 1 get one
          # (discount = 1), this means that the `elements` to be granted to such promotion is `2`

          # So we will have the following, individual_price: 3.11, amount: 3, elements: 2, discount: 1
          # remainer = (amount % elements)
          # amount_with_promotion = (amount - reminder) / elements
          # total_for_elements_with_promotion = amount_with_promotion * discount * individual_price
          # total_for_elements_without_promotion = individual_price * remainder
          # total = total_for_elements_with_promotion + total_for_elements_without_promotion

          # remainer = (3 % 2)
          # amount_with_promotion = (3 - 1) / 2
          # total_for_elements_with_promotion = 1 * 1 * 3.11
          # total_for_elements_without_promotion = 3.11 * 1

          # total = 3.11 + 3.11
          # total = 6.22

          elements_to_apply_promotion = Decimal.sub(amount, remainder)

          amount_with_promotion = Decimal.div(elements_to_apply_promotion, elements)
          total_for_elements_with_promotion = Decimal.mult(amount_with_promotion, amount_to_pay)

          total_for_elements_with_promotion =
            Decimal.mult(individual_price, total_for_elements_with_promotion)

          total_for_elements_without_promotion = Decimal.mult(individual_price, remainder)

          Decimal.add(total_for_elements_with_promotion, total_for_elements_without_promotion)
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

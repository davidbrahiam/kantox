defmodule Kantox.Chart.Worker do
  @moduledoc false
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{basket: []}, opts)
  end

  def init(state) do
    {:ok, state}
  end

  def basket_list(module) do
    GenServer.call(module, :basket_list)
  end

  def add_product(module, product) do
    GenServer.call(module, {:add_product, product})
  end

  def clear_basket(module) do
    GenServer.call(module, :clear_basket)
  end

  def remove_product(module, product) do
    GenServer.call(module, {:remove_product, product})
  end

  def handle_call(:basket_list, _, state) do
    {:reply, state, state}
  end

  def handle_call(:clear_basket, _, _) do
    state = %{basket: []}
    {:reply, state, state}
  end

  def handle_call({:add_product, product}, _, %{basket: basket}) do
    new_state = %{basket: [product | basket]}
    {:reply, new_state, new_state}
  end

  def handle_call({:remove_product, %{product_id: product_id, amount: amount}}, _, %{
        basket: basket
      })
      when is_integer(amount) do
    {basket, _} =
      Enum.reduce(basket, {[], amount}, fn
        ^product_id, {list, 0} ->
          {[product_id | list], 0}

        ^product_id, {list, amount} ->
          {list, amount - 1}

        item, {list, amount} ->
          {[item | list], amount}
      end)

    new_state = %{basket: basket}
    {:reply, new_state, new_state}
  end
end

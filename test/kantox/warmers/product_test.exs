defmodule Kantox.Warmers.ProductTest do
  @moduledoc false
  use ExUnit.Case

  setup do
    Mox.stub_with(Kantox.Store.Mock, Kantox.Store.ETS)

    table = :persistent_term.get(:products_table)
    :ok = Kantox.Store.clear_data(table)
    %{table: table}
  end

  @tag :warmer
  test "When it's initialized correctly", %{table: table} do
    Kantox.Warmers.Product.execute()

    assert Kantox.Store.get_by_id(table, "GR1") == %{id: "GR1", name: "Green tea", price: 3.11}
    assert Kantox.Store.get_by_id(table, "SR1") == %{id: "SR1", name: "Strawberries", price: 5.0}
    assert Kantox.Store.get_by_id(table, "CF1") == %{id: "CF1", name: "Coffee", price: 11.23}
  end

  @tag :warmer
  test "When it's not initialized no data are available", %{table: table} do
    assert is_nil(Kantox.Store.get_by_id(table, "GR1"))
    assert is_nil(Kantox.Store.get_by_id(table, "SR1"))
    assert is_nil(Kantox.Store.get_by_id(table, "CF1"))
  end
end

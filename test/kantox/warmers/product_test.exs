defmodule Kantox.Warmers.ProductTest do
  @moduledoc false
  use ExUnit.Case

  setup do
    Mox.stub_with(Kantox.Store.Mock, Kantox.Store.ETS)

    :ok = Kantox.Store.clear_data()
  end

  @tag :warmer
  test "When it's initialized correctly" do
    Kantox.Warmers.Product.execute()

    assert Kantox.Store.get_by_id("GR1") ==
             %Kantox.Models.Product{
               id: "GR1",
               name: "Green tea",
               price: Decimal.new("3.11"),
               promotion: %Kantox.Models.Promotion{
                 condition: :equal_to,
                 discount: Decimal.new("1.555"),
                 elements: 2
               }
             }

    assert Kantox.Store.get_by_id("SR1") ==
             %Kantox.Models.Product{
               id: "SR1",
               name: "Strawberries",
               price: Decimal.new("5.0"),
               promotion: %Kantox.Models.Promotion{
                 condition: :greater_than,
                 discount: Decimal.new("0.5"),
                 elements: 3
               }
             }

    assert Kantox.Store.get_by_id("CF1") ==
             %Kantox.Models.Product{
               id: "CF1",
               name: "Coffee",
               price: Decimal.new("11.23"),
               promotion: %Kantox.Models.Promotion{
                 condition: :greater_than,
                 discount: Decimal.new("7.4867"),
                 elements: 3
               }
             }
  end

  @tag :warmer
  test "When it's not initialized no data are available" do
    assert is_nil(Kantox.Store.get_by_id("GR1"))
    assert is_nil(Kantox.Store.get_by_id("SR1"))
    assert is_nil(Kantox.Store.get_by_id("CF1"))
  end
end

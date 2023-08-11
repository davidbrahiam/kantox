defmodule KantoxWeb.Services.Products.PurchaseTest do
  use ExUnit.Case

  doctest KantoxWeb.Services.Products.Purchase

  setup do
    Mox.stub_with(Kantox.Store.Mock, Kantox.Store.ETS)
    :ok = Kantox.Store.clear_data()
    :ok = Kantox.Warmers.Product.execute()
  end

  @tag :purchase_service
  test "when requested returns the total amount to pay given a basket" do
    basket = %{basket: ["GR1", "SR1", "CF1"]}

    response = KantoxWeb.Services.Products.Purchase.purchase(basket)

    assert response == {:ok, %{total: "19.34"}}
  end

  @tag :purchase_service
  test "when requested equal_to promotion" do
    basket = %{basket: ["GR1", "GR1", "SR1", "CF1"]}

    response = KantoxWeb.Services.Products.Purchase.purchase(basket)

    assert response == {:ok, %{total: "19.34"}}
  end

  @tag :purchase_service
  test "when requested equal_to promotion and extra amount" do
    basket = %{basket: ["GR1", "GR1", "GR1", "GR1", "GR1", "SR1", "CF1"]}

    response = KantoxWeb.Services.Products.Purchase.purchase(basket)

    assert response == {:ok, %{total: "25.56"}}
  end

  @tag :purchase_service
  test "when requested the order of the elements doesn't matter it still returns the same result" do
    basket = %{basket: Enum.shuffle(["GR1", "SR1", "GR1", "GR1", "CF1", "GR1", "GR1"])}

    response = KantoxWeb.Services.Products.Purchase.purchase(basket)

    assert response == {:ok, %{total: "25.56"}}
  end

  @tag :purchase_service
  test "when requested greater_than promotion and extra amount" do
    basket = %{basket: ["GR1", "SR1", "SR1", "SR1", "GR1", "SR1", "CF1"]}

    response = KantoxWeb.Services.Products.Purchase.purchase(basket)

    assert response == {:ok, %{total: "32.34"}}
  end

  @tag :purchase_service
  test "when requested products without promotion" do
    basket = %{basket: ["GR1", "SR1", "SR1", "CF1", "CF1"]}

    response = KantoxWeb.Services.Products.Purchase.purchase(basket)

    assert response == {:ok, %{total: "35.57"}}
  end

  @tag :purchase_service
  test "when requested greater_than promotion and extra teas" do
    basket = %{basket: ["GR1", "GR1", "GR1", "GR1", "GR1", "SR1", "CF1"]}

    response = KantoxWeb.Services.Products.Purchase.purchase(basket)

    assert response == {:ok, %{total: "25.56"}}
  end

  @tag :purchase_service
  test "when requested greater_than promotion and extra coffes" do
    basket = %{basket: ["CF1", "CF1", "CF1", "CF1", "CF1", "SR1", "CF1"]}

    response = KantoxWeb.Services.Products.Purchase.purchase(basket)

    assert response == {:ok, %{total: "49.92"}}
  end
end

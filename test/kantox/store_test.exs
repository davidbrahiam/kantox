defmodule Kantox.StoreTest do
  @moduledoc false
  use ExUnit.Case

  setup do
    Mox.stub_with(Kantox.Store.Mock, Kantox.Store.ETS)
    table = :persistent_term.get(:products_table)
    :ok = Kantox.Store.clear_data(table)
    %{table: table}
  end

  describe "insert/2" do
    @tag :ets_insert
    test "when a item it's inserted it returns success", %{table: table} do
      assert Kantox.Store.insert(table, {"key1", 2}) == :ok
      assert Kantox.Store.get_by_id(table, "key1") == 2
    end

    @tag :ets_insert
    test "if the insert operation fails returns error" do
      assert_raise ArgumentError, fn ->
        Kantox.Store.insert(:table2, {"key1", 2}) == :ok
      end
    end
  end

  describe "delete/2" do
    @tag :ets_delete
    test "when a item it's deleted it returns success", %{table: table} do
      assert Kantox.Store.insert(table, {"key1", 2}) == :ok
      assert Kantox.Store.delete(table, "key1") == :ok
    end

    @tag :ets_delete
    test "if delete operation fails returns error", %{table: table} do
      assert Kantox.Store.delete(table, "key2") == :ok
    end

    @tag :ets_delete
    test "if the delete operation fails returns error" do
      assert_raise ArgumentError, fn ->
        Kantox.Store.delete(:table2, "key3") == :ok
      end
    end
  end

  describe "get/2" do
    @tag :ets_get
    test "when getting an item it returns success", %{table: table} do
      assert Kantox.Store.insert(table, {"key1", 2}) == :ok
      assert Kantox.Store.get_by_id(table, "key1") == 2
    end

    @tag :ets_get
    test "when item not found returns nil", %{table: table} do
      assert Kantox.Store.get_by_id(table, "key3") == nil
    end

    @tag :ets_get
    test "if get operation fails returns error" do
      assert_raise ArgumentError, fn ->
        Kantox.Store.get_by_id(:table2, "key3") == :ok
      end
    end
  end

  describe "clear_data/1" do
    @tag :ets_get
    test "when executed clears all previous data from the given table", %{table: table} do
      assert Kantox.Store.insert(table, {"key1", 2}) == :ok
      assert Kantox.Store.get_by_id(table, "key1") == 2
      assert Kantox.Store.clear_data(table) == :ok
      assert is_nil(Kantox.Store.get_by_id(table, "key1"))
    end
  end
end

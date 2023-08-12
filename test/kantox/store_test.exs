defmodule Kantox.StoreTest do
  @moduledoc false
  use ExUnit.Case

  setup do
    Mox.stub_with(Kantox.Store.Mock, Kantox.Store.ETS)

    :ok = Kantox.Store.clear_data()
  end

  describe "insert/2" do
    @tag :ets_insert
    test "when a item it's inserted it returns success" do
      assert Kantox.Store.insert({"key1", 2}) == :ok
      assert Kantox.Store.get_by_id("key1") == 2
    end

    @tag :ets_insert
    test "if the insert operation fails returns error" do
      assert_raise ArgumentError, fn ->
        Kantox.Store.insert(%{"key1" => 2})
      end
    end
  end

  describe "delete/2" do
    @tag :ets_delete
    test "when a item it's deleted it returns success" do
      assert Kantox.Store.insert({"key1", 2}) == :ok
      assert Kantox.Store.delete("key1") == :ok
    end

    @tag :ets_delete
    test "when attempting to delete a key that doens't exist returns success" do
      assert Kantox.Store.delete("key2") == :ok
    end
  end

  describe "get/2" do
    @tag :ets_get
    test "when getting an item it returns success" do
      assert Kantox.Store.insert({"key1", 2}) == :ok
      assert Kantox.Store.get_by_id("key1") == 2
    end

    @tag :ets_get
    test "when item not found returns nil" do
      assert Kantox.Store.get_by_id("key3") == nil
    end
  end

  describe "all/1" do
    @tag :ets_all
    test "when executed returns all objects present" do
      assert Kantox.Store.all() == []
      assert Kantox.Store.insert({"key1", 2}) == :ok
      assert Kantox.Store.all() == [{"key1", 2}]
    end
  end

  describe "clear_data/1" do
    @tag :ets_clear_data
    test "when executed clears all previous data from the store" do
      assert Kantox.Store.insert({"key1", 2}) == :ok
      assert Kantox.Store.get_by_id("key1") == 2
      assert Kantox.Store.clear_data() == :ok
      assert is_nil(Kantox.Store.get_by_id("key1"))
    end
  end
end

defmodule Kantox.Store.ETS do
  @moduledoc false
  @behaviour Kantox.Store

  @impl true
  def insert(table, item) do
    true = :ets.insert(table, item)
    :ok
  end

  @impl true
  def delete(table, id) do
    true = :ets.delete(table, id)
    :ok
  end

  @impl true
  def get_by_id(table, id) do
    query = [{{:"$1", :"$2"}, [{:==, :"$1", id}], [:"$2"]}]

    case :ets.select(table, query) do
      [val | _] -> val
      _ -> nil
    end
  end
end

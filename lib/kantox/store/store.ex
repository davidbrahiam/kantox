defmodule Kantox.Store do
  @moduledoc false

  @adapter Application.compile_env(:kantox, __MODULE__, Kantox.Store.ETS)

  @callback insert(tuple() | map()) :: :ok
  defdelegate insert(item), to: @adapter

  @callback delete(integer()) :: :ok
  defdelegate delete(id), to: @adapter

  @callback get_by_id(integer()) :: {:ok, map()} | {:error, any()}
  defdelegate get_by_id(id), to: @adapter

  @callback all() :: list()
  defdelegate all(), to: @adapter

  @callback clear_data() :: :ok
  defdelegate clear_data(), to: @adapter
end

defmodule Kantox.Warmer do
  @moduledoc false

  @callback execute() :: :ok

  defmacro __using__(_) do
    quote do
      use GenServer

      @behaviour Kantox.Warmer

      def start_link(_) do
        GenServer.start_link(__MODULE__, nil, name: __MODULE__)
      end

      def init(state) do
        {:ok, state, {:continue, :first_execute}}
      end

      def handle_continue(:first_execute, _state) do
        :ok = execute()
        {:noreply, nil}
      end
    end
  end
end

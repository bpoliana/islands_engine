defmodule IslandsEngine.Game do
  use GenServer

  def demo_call(game) do
    GenServer.call(game, :demo_call)
  end

  def handle_info(:first, state) do
    IO.puts("This message has been handled by handle_info/2, matching on :first")
    {:noreply, state}
  end

  def handle_call(:demo_call, _from, state) do
    {:reply, state, state}
  end
end

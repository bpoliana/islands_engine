defmodule IslandsEngine.Guesses do
  alias __MODULE__

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  def new(), do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  # {:ok, coordinate1} = Coordinate.new(1,1)
  # {:ok, coordinate2} = Coordinate.new(2,2)
  # guesses = update_in(guesses.hits, &MapSet.put(&1, coordinate1))
  # guesses = update_in(guesses.hits, &MapSet.put(&1, coordinate2))
end

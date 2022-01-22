defmodule IslandsEngine.Guesses do
  alias __MODULE__
  alias IslandsEngine.{Coordinate, Guesses}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  def new(), do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate),
    do: update_in(guesses.hits, &MapSet.put(&1, coordinate))

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate),
    do: update_in(guesses.misses, &MapSet.put(&1, coordinate))

  # {:ok, coordinate1} = Coordinate.new(1,1)
  # {:ok, coordinate2} = Coordinate.new(2,2)
  # guesses = update_in(guesses.hits, &MapSet.put(&1, coordinate1))
  # guesses = update_in(guesses.hits, &MapSet.put(&1, coordinate2))
end

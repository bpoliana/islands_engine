defmodule IslandsEngine.Board do
  alias IslandsEngine.{Island, Coordinate}

  def new(), do: %{}

  def position_island(board, key, %Island{} = island) do
    case overlaps_existing_island?(board, key, island) do
      true -> {:error, :overlapping_island}
      false -> Map.put(board, key, island)
    end
  end

  # gets the list of valid island types from the Island.types/0
  def all_islands_positioned?(board), do: Enum.all?(Island.types(), &Map.has_key?(board, &1))

  def guess(board, %Coordinate{} = coordinate) do
    board
    |> check_all_islands(coordinate)
    |> guess_response(board)
  end

  defp check_all_islands(board, coordinate) do
    Enum.find_value(board, :miss, fn {key, island} ->
      case Island.guess(island, coordinate) do
        {:hit, island} -> {key, island}
        :miss -> false
      end
    end)
  end

  defp guess_response({key, island}, board) do
    board = %{board | key => island}
    {:hit, forest_check(board, key), win_check(board), board}
  end

  defp guess_response(:miss, board), do: {:miss, :none, :no_win, board}

  defp forest_check(board, key) do
    case forested?(board, key) do
      true -> key
      false -> :none
    end
  end

  defp forested?(board, key) do
    board
    |> Map.fetch!(key)
    |> Island.forested?()
  end

  defp win_check(board) do
    case all_forested?(board) do
      true -> :win
      false -> :no_win
    end
  end

  defp all_forested?(board) do
    Enum.all?(board, fn {_key, island} -> Island.forested?(island) end)
  end

  defp overlaps_existing_island?(board, new_key, new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end
end

# Creating 2 islands and positioning them on board

# {:ok, square_coordinate} = Coordinate.new(1,1)
# {:ok, square} = Island.new(:dot, square_coordinate)
# Board.position_island(board, :square, square)

# {:ok, new_dot_coordinate} = Coordinate.new(3,3)
# {:ok, dot} = Island.new(:dot, new_dot_coordinate)
# Board.position_island(board, :dot, dot)
# %{
#   dot: %IslandsEngine.Island{
#     coordinates: #MapSet<[%IslandsEngine.Coordinate{col: 3, row: 3}]>,
#     hit_coordinates: #MapSet<[]>
#   },
#   square: %IslandsEngine.Island{
#     coordinates: #MapSet<[
#       %IslandsEngine.Coordinate{col: 1, row: 1},
#       %IslandsEngine.Coordinate{col: 1, row: 2},
#       %IslandsEngine.Coordinate{col: 2, row: 1},
#       %IslandsEngine.Coordinate{col: 2, row: 2}
#     ]>,
#     hit_coordinates: #MapSet<[
#       %IslandsEngine.Coordinate{col: 1, row: 1},
#       %IslandsEngine.Coordinate{col: 1, row: 2},
#       %IslandsEngine.Coordinate{col: 2, row: 1},
#       %IslandsEngine.Coordinate{col: 2, row: 2}
#     ]>
#   }
# }
# Guessing a coordinate that does not hit an island

# iex> {:ok, guess_coordinate} = Coordinate.new(10,10)
# {:ok, %IslandsEngine.Coordinate{col: 10, row: 10}}
# iex> {:miss, :none, :no_win, board} = Board.guess(board, guess_coordinate)
# {:miss, :none, :no_win,
#  %{
#    square: %IslandsEngine.Island{
#      coordinates: #MapSet<[
#        %IslandsEngine.Coordinate{col: 1, row: 1},
#        %IslandsEngine.Coordinate{col: 1, row: 2},
#        %IslandsEngine.Coordinate{col: 2, row: 1},
#        %IslandsEngine.Coordinate{col: 2, row: 2}
#      ]>,
#      hit_coordinates: #MapSet<[]>
#    }
# }}

# # Guessing a hit coordinate that is part of an island but still does not win the game

# iex> {:ok, hit_coordinate} = Coordinate.new(1,1)
# {:ok, %IslandsEngine.Coordinate{col: 1, row: 1}}
# iex> {:hit, :none, :no_win, board} = Board.guess(board, hit_coordinate)
# {:hit, :none, :no_win,
#  %{
#    square: %IslandsEngine.Island{
#      coordinates: #MapSet<[
#        %IslandsEngine.Coordinate{col: 1, row: 1},
#        %IslandsEngine.Coordinate{col: 1, row: 2},
#        %IslandsEngine.Coordinate{col: 2, row: 1},
#        %IslandsEngine.Coordinate{col: 2, row: 2}
#      ]>,
#      hit_coordinates: #MapSet<[
#        %IslandsEngine.Coordinate{col: 1, row: 1}
#      ]>
#    }
#  }}

# [Cheat] Making the square`s hit coordinates equal to its coordinates
# which make it a forested island, and will leave the single coordinate of the dot island
# as the only unguessed coordinate

# iex(19)> square = %{square | hit_coordinates: square.coordinates}
# iex(20)> board = Board.position_island(board, :square, square)
# {:hit, :dot, :win,
#  %{
#    dot: %IslandsEngine.Island{
#      coordinates: #MapSet<[%IslandsEngine.Coordinate{col: 3, row: 3}]>,
#      hit_coordinates: #MapSet<[%IslandsEngine.Coordinate{col: 3, row: 3}]>
#    },
#    square: %IslandsEngine.Island{
#      coordinates: #MapSet<[
#        %IslandsEngine.Coordinate{col: 1, row: 1},
#        %IslandsEngine.Coordinate{col: 1, row: 2},
#        %IslandsEngine.Coordinate{col: 2, row: 1},
#        %IslandsEngine.Coordinate{col: 2, row: 2}
#      ]>,
#      hit_coordinates: #MapSet<[
#        %IslandsEngine.Coordinate{col: 1, row: 1},
#        %IslandsEngine.Coordinate{col: 1, row: 2},
#        %IslandsEngine.Coordinate{col: 2, row: 1},
#        %IslandsEngine.Coordinate{col: 2, row: 2}
#      ]>
#    }
#  }}
# Now, when we guess the dot coordinate, we should get a :hit and :wind

# iex(25)> {:ok, win_coordinate} = Coordinate.new(3,3)
# {:ok, %IslandsEngine.Coordinate{col: 3, row: 3}}

# iex(29)> board1 =Board.position_island(board, :dot, dot)

# iex(30)> {:hit, :dot, :win, board} = Board.guess(board1, win_coordinate)
# {:hit, :dot, :win,
#  %{
#    dot: %IslandsEngine.Island{
#      coordinates: #MapSet<[%IslandsEngine.Coordinate{col: 3, row: 3}]>,
#      hit_coordinates: #MapSet<[%IslandsEngine.Coordinate{col: 3, row: 3}]>
#    },
#    square: %IslandsEngine.Island{
#      coordinates: #MapSet<[
#        %IslandsEngine.Coordinate{col: 1, row: 1},
#        %IslandsEngine.Coordinate{col: 1, row: 2},
#        %IslandsEngine.Coordinate{col: 2, row: 1},
#        %IslandsEngine.Coordinate{col: 2, row: 2}
#      ]>,
#      hit_coordinates: #MapSet<[
#        %IslandsEngine.Coordinate{col: 1, row: 1},
#        %IslandsEngine.Coordinate{col: 1, row: 2},
#        %IslandsEngine.Coordinate{col: 2, row: 1},
#        %IslandsEngine.Coordinate{col: 2, row: 2}
#      ]>
#    }
#  }}

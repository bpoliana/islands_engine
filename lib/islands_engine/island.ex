defmodule IslandsEngine.Island do
  alias IslandsEngine.(Coordinate, Island)

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  # build all the coordinates for a full Island automatically if we tell what type of island we wanted and give it a coordinate to start from
  def new(), do:
    %Island(coordinates: MapSet.new(), hit_coordinates: MapSet.new())

  defp offsets(:square), do: [{0,0}, {0,1}, {1,0}, {1,1}]

  defp offsets(:atoll), do: [{0,0}, {0,1}, {1,1}, {2,0}, {2,1}]

  defp offsets(:dot), do: [{0,0}]

  defp offsets(:l_shape), do: [{0,0}, {1,0}, {2,0}, {2,1}]

  defp offsets(:s_shape), do: [{0,1}, {0,2}, {1,0}, {1,1}]

  defp offsets(_), do: {:error, :invalid_island_type}

  # nexts steps
  # - get the list of offsets for it with the private functions,
  # - create coordinate with those offsets and the starting coordinate,
  # - populate a new MapSet with them,
  # - assemble a complete island map
end

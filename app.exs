# Imports
Code.require_file("./input.exs")

IO.puts("How to use:")
IO.puts("")
IO.puts("1 - Set coords separated by space. (i.e.: \"5 5\" or \"5 5 N\")")
IO.puts("")

[
  %{name: "Sonda 1", direction: "N", x: 0, y: 0},
  %{name: "Sonda 2", direction: "N", x: 0, y: 0},
  %{name: "Sonda 3", direction: "N", x: 0, y: 0},
  %{name: "Sonda 4", direction: "N", x: 0, y: 0},
  %{name: "Sonda 5", direction: "N", x: 0, y: 0}
]
|> Enum.reduce_while([], fn item, items ->
  Input.get_coords("#{item.name} -> Set my coords: ")
  |> case do
    {:ok, %{x: _x, y: _y, actions: _actions} = coords} ->
      item = Map.put(item, :coords, coords)
      {:cont, items ++ [item]}

    {:ok, %{x: _x, y: _y} = coords} ->
      coords = Map.put(coords, :actions, [])
      item = Map.put(item, :coords, coords)
      {:cont, items ++ [item]}

    {:ok, %{actions: _actions} = coords} ->
      coords =
        coords
        |> Map.put(:x, item.init.x)
        |> Map.put(:y, item.init.y)

      item = Map.put(item, :coords, coords)
      {:cont, items ++ [item]}

    {:error, reason} ->
      {:halt, {:error, reason}}
  end
end)
|> case do
  {:error, reason} ->
    IO.warn(reason)

  items when is_list(items) ->
    items =
      items
      |> Enum.map(&Map.delete(&1, :init))

    IO.inspect(items)
end

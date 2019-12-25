# Imports
Code.require_file("./input.exs")
Code.require_file("./nasa.exs")

IO.puts("Gloussary:")
IO.puts("")
IO.puts("DIRECTION = initial direction (N/E/S/W)")
IO.puts("ACTION = one or more actions (M/L/R)")
IO.puts("X = coordenate x")
IO.puts("Y = coordenate y")
IO.puts("")
IO.puts("How to use:")
IO.puts("")
IO.puts("1 - Set inputs separated by space")
IO.puts("2 - You can send these type of data:")
IO.puts("    * ACTION")
IO.puts("    * X Y")
IO.puts("    * X Y ACTION")
IO.puts("    * X Y DIRECTION")
IO.puts("    * X Y DIRECTION ACTION")
IO.puts("")

[
  %{name: "Probe 1", direction: "N", x: 0, y: 0},
  %{name: "Probe 2", direction: "N", x: 0, y: 0},
  %{name: "Probe 3", direction: "N", x: 0, y: 0},
  %{name: "Probe 4", direction: "N", x: 0, y: 0},
  %{name: "Probe 5", direction: "N", x: 0, y: 0}
]
|> Enum.reduce_while([], fn item, items ->
  Input.get_coords("#{item.name} -> Set my coords: ")
  |> case do
    {:ok, %{x: x, y: y, actions: actions, direction: direction}} when is_integer(x) and is_integer(y) and is_list(actions) and is_binary(direction) ->
      item =
        item
        |> Map.put(:x, x)
        |> Map.put(:y, y)
        |> Map.put(:direction, direction)

      {:cont, items ++ [%{
        item: item,
        actions: actions
      }]}

    {:ok, %{x: x, y: y, actions: actions}} when is_integer(x) and is_integer(y) and is_list(actions) ->
      item =
        item
        |> Map.put(:x, x)
        |> Map.put(:y, y)

      {:cont, items ++ [%{
        item: item,
        actions: actions
      }]}

    {:ok, %{x: x, y: y, direction: direction}} when is_integer(x) and is_integer(y) and is_binary(direction) ->
      item =
        item
        |> Map.put(:x, x)
        |> Map.put(:y, y)
        |> Map.put(:y, direction)

      {:cont, items ++ [%{
        item: item,
        actions: []
      }]}

    {:ok, %{x: x, y: y}} when is_integer(x) and is_integer(y) ->
      item =
        item
        |> Map.put(:x, x)
        |> Map.put(:y, y)

      {:cont, items ++ [%{
        item: item,
        actions: []
      }]}

    {:ok, %{actions: actions}} when is_list(actions) ->
      item =
        item
        |> Map.put(:x, 0)
        |> Map.put(:y, 0)

      {:cont, items ++ [%{
        item: item,
        actions: actions
      }]}

    {:error, reason} ->
      {:halt, {:error, reason}}
  end
end)
|> case do
  {:error, reason} ->
    IO.warn(reason)

  items when is_list(items) ->
    items
    |> Nasa.call()
end

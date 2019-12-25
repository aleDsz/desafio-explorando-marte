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
    {:ok, %{x: x, y: y, actions: actions}} when is_integer(x) and is_integer(y) and is_list(actions) ->
      item =
        item
        |> Map.put(:x, x)
        |> Map.put(:y, y)

      {:cont, items ++ [%{
        item: item,
        actions: actions
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
    items =
      items
      |> Enum.map(&Map.delete(&1, :init))

    IO.inspect(items)
end

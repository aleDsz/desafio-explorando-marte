defmodule Nasa do
  def call(items) when is_list(items) do
    items
    |> Enum.map(fn %{item: item, actions: actions} ->
      item
      |> send_action_to_probe(actions)
    end)
    |> generate_results()
  end

  defp generate_results(items) when is_list(items) do
    items
    |> Enum.each(&generate_result/1)
  end

  defp generate_result(%{x: x, y: y, direction: direction}), do: IO.puts("#{x} #{y} #{direction}")

  defp send_action_to_probe(item, actions) do
    actions
    |> Enum.reduce(item, &execute_action(&2, &1))
  end

  # Move
  defp execute_action(%{y: y, direction: "N"} = item, "M"), do: item |> Map.put(:y, y + 1)
  defp execute_action(%{x: x, direction: "E"} = item, "M"), do: item |> Map.put(:x, x + 1)
  defp execute_action(%{y: y, direction: "S"} = item, "M"), do: item |> Map.put(:y, y - 1)
  defp execute_action(%{x: x, direction: "W"} = item, "M"), do: item |> Map.put(:x, x - 1)

  # Roll
  defp execute_action(%{direction: "N"} = item, "L"), do: item |> Map.put(:direction, "W")
  defp execute_action(%{direction: "N"} = item, "R"), do: item |> Map.put(:direction, "E")

  defp execute_action(%{direction: "E"} = item, "L"), do: item |> Map.put(:direction, "N")
  defp execute_action(%{direction: "E"} = item, "R"), do: item |> Map.put(:direction, "S")

  defp execute_action(%{direction: "S"} = item, "L"), do: item |> Map.put(:direction, "E")
  defp execute_action(%{direction: "S"} = item, "R"), do: item |> Map.put(:direction, "W")

  defp execute_action(%{direction: "W"} = item, "L"), do: item |> Map.put(:direction, "S")
  defp execute_action(%{direction: "W"} = item, "R"), do: item |> Map.put(:direction, "N")
end

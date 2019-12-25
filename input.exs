defmodule Input do
  def get(message) when is_binary(message) do
    message
    |> IO.gets()
    |> String.replace("\n", "")
  end

  def get_coords(message) when is_binary(message) do
    message
    |> IO.gets()
    |> String.replace("\n", "")
    |> String.split(" ")
    |> case do
      [x, y, direction, actions] when direction in ["N", "E", "S", "W"] ->
        {:ok, x} = validate_coord(x)
        {:ok, y} = validate_coord(y)
        {:ok, actions} = validate_actions(actions)

        {:ok, %{x: x, y: y, direction: direction, actions: actions}}

      [x, y, direction] when direction in ["N", "E", "S", "W"] ->
        {:ok, x} = validate_coord(x)
        {:ok, y} = validate_coord(y)

        {:ok, %{x: x, y: y, direction: direction}}

      [x, y, actions] ->
        {:ok, x} = validate_coord(x)
        {:ok, y} = validate_coord(y)
        {:ok, actions} = validate_actions(actions)

        {:ok, %{x: x, y: y, actions: actions}}

      [x, y] ->
        {:ok, x} = validate_coord(x)
        {:ok, y} = validate_coord(y)

        {:ok, %{x: x, y: y}}

      [actions] ->
        {:ok, actions} = validate_actions(actions)
        {:ok, %{actions: actions}}

      _ ->
        {:error, "Not all coords has been taken from input"}
    end
  end

  defp validate_coord(coord) when is_binary(coord) do
    try do
      {:ok, String.to_integer(coord)}
    rescue
      _ ->
        {:error, "Can't convert #{coord} into integer"}
    end
  end

  defp validate_actions(actions) when is_binary(actions) do
    0..(String.length(actions) - 1)
    |> Enum.reduce_while({:ok, []}, fn index, {:ok, validated_actions} ->
      action = String.slice(actions, index..index)

      case validate_action(action) do
        {:ok, action} ->
          {:cont, {:ok, validated_actions ++ [action]}}

        {:error, reason} ->
          {:halt, {:error, reason}}
      end
    end)
  end

  defp validate_action(action) when action in ["M", "L", "R"], do: {:ok, action}
  defp validate_action(action), do: {:error, "Received an invalid action: #{action}"}
end

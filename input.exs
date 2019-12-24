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
    {:ok, actions}
  end
end

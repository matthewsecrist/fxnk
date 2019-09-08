defmodule Fxnk.Map do
  @moduledoc """
  `Fxnk.Map` are functions that work with maps.
  """
  import Fxnk.Functions, only: [curry: 1]

  @doc """
  `pick/1`

  Accepts a list of args, returns a curried `pick/2`.

  ## Examples
      iex> pickArgs = Fxnk.Map.pick([:red, :blue, :orange])
      iex> pickArgs.(%{ red: "RED", green: "GREEN", blue: "BLUE", yellow: "YELLOW" })
      %{red: "RED", blue: "BLUE"}
  """
  @spec pick([atom(), ...]) :: fun
  def pick(args) when is_list(args) do
    curry(fn map -> pick(map, args) end)
  end

  @doc """
  `pick/2` takes a `Map` and a `List` of atoms, and returns a map of only the selected keys that exist. It will
  return an empty map if passed an empty map or an empty list.

  ## Examples
      iex> Fxnk.Map.pick(%{ red: "RED", green: "GREEN", blue: "BLUE", yellow: "YELLOW" }, [:red, :blue, :orange])
      %{red: "RED", blue: "BLUE"}
  """
  @spec pick(map, [atom(), ...]) :: map
  def pick(map, _) when map_size(map) == 0, do: %{}
  def pick(_, []), do: %{}

  def pick(map, args) when is_map(map) and is_list(args) do
    do_pick(map, args, %{})
  end

  defp do_pick(_, [], acc), do: acc

  defp do_pick(map, [hd | tl], acc) do
    case Map.fetch(map, hd) do
      {:ok, val} -> do_pick(map, tl, Map.put(acc, hd, val))
      _ -> do_pick(map, tl, acc)
    end
  end
end

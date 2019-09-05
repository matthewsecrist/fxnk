defmodule Fxnk.Pick do
  import Fxnk.Curry

  @moduledoc """
  Documentation for `Fxnk.Pick`

  Pick properties off of a map.
  """

  @doc """
  `pick/1`

  Accepts a list of args, returns a curried `pick/2`.

  ## Examples
      iex> pickArgs = Fxnk.Pick.pick([:red, :blue])
      iex> pickArgs.(%{ red: "RED", green: "GREEN", blue: "BLUE", yellow: "YELLOW" })
      %{red: "RED", blue: "BLUE"}
  """
  @spec pick([atom(), ...]) :: fun
  def pick(args) when is_list(args) do
    curry(fn map -> pick(map, args) end)
  end

  @doc """
  `pick/2` takes a `Map` and a `List` of atoms, and returns a map of only the selected keys.

  ## Examples
      iex> Fxnk.Pick.pick(%{ red: "RED", green: "GREEN", blue: "BLUE", yellow: "YELLOW" }, [:red, :blue])
      %{red: "RED", blue: "BLUE"}
  """
  @spec pick(map, [atom(), ...]) :: map
  def pick(map, args) when is_map(map) and is_list(args) do
    do_pick(map, args, %{})
  end

  defp do_pick(_, [], acc), do: acc
  defp do_pick(map, _, _) when map_size(map) == 0, do: %{}

  defp do_pick(map, [hd | tl], acc) do
    case Map.fetch(map, hd) do
      {:ok, val} -> do_pick(map, tl, Map.put(acc, hd, val))
      _ -> do_pick(map, tl, acc)
    end
  end
end

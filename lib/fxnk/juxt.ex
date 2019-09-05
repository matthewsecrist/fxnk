defmodule Fxnk.Juxt do
  import Fxnk.Curry

  @moduledoc """
  Documentation for `Fxnk.Juxt`

  Juxt takes an initial argument and applies a list of functions to it.
  """

  @doc """
  `juxt/1` takes list of functions and returns a curried juxt.

  ## Example
      iex> minmax = Fxnk.Juxt.juxt([&Fxnk.Math.min/1, &Fxnk.Math.max/1])
      iex> minmax.([1,3,5,7])
      [1, 7]
  """
  @spec juxt([function(), ...]) :: fun()
  def juxt(fns) when is_list(fns) do
    curry(fn arg -> juxt(arg, fns) end)
  end

  @doc """
  `juxt/2` takes an initial argument and list of functions and applies the functions to the argument.

  ## Example
      iex> Fxnk.Juxt.juxt([1, 3, 5, 7], [&Fxnk.Math.min/1, &Fxnk.Math.max/1])
      [1, 7]
  """
  @spec juxt(any, [function(), ...]) :: any
  def juxt(arg, fns) do
    perform_juxt(arg, fns, [])
  end

  defp perform_juxt(arg, [hd | []], results), do: [hd.(arg) | results] |> Enum.reverse()
  defp perform_juxt(arg, [hd | tl], results), do: perform_juxt(arg, tl, [hd.(arg) | results])
end

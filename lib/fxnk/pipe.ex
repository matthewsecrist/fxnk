defmodule Fxnk.Pipe do
  import Fxnk.Curry

  @moduledoc """
  Documentation for Fxnk.Pipe
  """

  @doc """
  `pipe/1` returns a curried `Pipe`

  ## Examples

      iex> import Fxnk.Pipe
      Fxnk.Pipe
      iex> reverseSort = pipe([&Enum.sort/1, &Enum.reverse/1])
      iex> reverseSort.([1,3,5,7,6,4,2])
      [7, 6, 5, 4, 3, 2, 1]
  """
  @spec pipe([function(), ...]) :: fun()
  def pipe(fns) when is_list(fns) do
    curry(fn arg -> pipe(arg, fns) end)
  end

  @doc """
  `pipe/2` is a pipeable `Pipe`

  ## Examples

      iex> import Fxnk.Pipe
      Fxnk.Pipe
      iex> [1,3,5,7,6,4,2] |> pipe([&Enum.sort/1, &Enum.reverse/1])
      [7, 6, 5, 4, 3, 2, 1]
  """
  @spec pipe(any, [function(), ...]) :: any
  def pipe(arg, fns) when is_list(fns) do
    Enum.reduce(fns, arg, fn f, acc -> f.(acc) end)
  end
end

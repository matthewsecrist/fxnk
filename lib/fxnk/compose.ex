defmodule Fxnk.Compose do
  import Fxnk.Curry
  import Fxnk.ReduceRight

  @moduledoc """
  Documentation for Fxnk.Compose.
  """

  @doc """
  `compose/1` returns a curried `Compose`

  ## Examples

      iex> import Fxnk.Compose
      Fxnk.Compose
      iex> reverseSort = compose([&Enum.reverse/1, &Enum.sort/1])
      #Function<0.93910723/1 in Fxnk.Curry.curry/3>
      iex> reverseSort.([1,3,5,7,6,4,2])
      [7, 6, 5, 4, 3, 2, 1]

  """
  @spec compose([function(), ...]) :: fun()
  def compose(fns) when is_list(fns) do
    curry(fn arg -> compose(arg, fns) end)
  end

  @doc """
  `compose/2` is a pipeable `Compose`.

  ## Examples

      iex> import Fxnk.Compose
      Fxnk.Compose
      iex> [1,3,5,7,6,4,2] |> compose([&Enum.reverse/1, &Enum.sort/1])
      [7, 6, 5, 4, 3, 2, 1]

  """
  @spec compose(any, [function(), ...]) :: any
  def compose(arg, fns) when is_list(fns) do
    reduce_right(fns, arg, fn f, acc -> f.(acc) end)
  end
end

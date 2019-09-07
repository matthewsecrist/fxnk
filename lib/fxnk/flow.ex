defmodule Fxnk.Flow do
  import Fxnk.Functions, only: [curry: 1]
  import Fxnk.List, only: [reduce_right: 3]

  @doc """
  `compose/1` returns a curried `Compose`

  ## Examples
      iex> reverseSort = Fxnk.Flow.compose([&Enum.reverse/1, &Enum.sort/1])
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
      iex> [1,3,5,7,6,4,2] |> Fxnk.Flow.compose([&Enum.reverse/1, &Enum.sort/1])
      [7, 6, 5, 4, 3, 2, 1]
  """
  @spec compose(any, [function(), ...]) :: any
  def compose(arg, fns) when is_list(fns) do
    reduce_right(fns, arg, fn f, acc -> f.(acc) end)
  end

  @doc """
  `pipe/1` returns a curried `Pipe`

  ## Examples
      iex> reverseSort = Fxnk.Flow.pipe([&Enum.sort/1, &Enum.reverse/1])
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
      iex> [1,3,5,7,6,4,2] |> Fxnk.Flow.pipe([&Enum.sort/1, &Enum.reverse/1])
      [7, 6, 5, 4, 3, 2, 1]
  """
  @spec pipe(any, [function(), ...]) :: any
  def pipe(arg, fns) when is_list(fns) do
    Enum.reduce(fns, arg, fn f, acc -> f.(acc) end)
  end
end

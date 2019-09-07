defmodule Fxnk.List do
  @doc """
  `reduce_right/3` takes a list of args, an initial value and a function and returns a single value.

  Like reduce, it applies the function to each of the arguments, and accumulating the result, except it does it right to left.

  ## Examples
      iex> Fxnk.List.reduce_right([1,2,3,4,5], 0, fn a, b -> a + b end)
      15
  """
  @spec reduce_right(list(any), any, function()) :: any
  def reduce_right(args, initial, func) do
    args
    |> Enum.reverse()
    |> Enum.reduce(initial, func)
  end
end

defmodule Fxnk.Math do
  import Fxnk.Functions, only: [curry: 1]

  @moduledoc """
  Mathy stuff.
  """

  @doc """
  Find the maximum of a list.

  ## Example
      iex> Fxnk.Math.max([1337, 42, 23])
      1337
  """
  @spec max([...]) :: any
  def max([hd | _] = args) do
    find_max(args, hd)
  end

  defp find_max([hd | []], max) when hd < max, do: max
  defp find_max([hd | []], max) when hd > max, do: hd
  defp find_max([hd | []], _), do: hd
  defp find_max([hd | tail], max) when hd < max, do: find_max(tail, max)
  defp find_max([hd | tail], max) when hd > max, do: find_max(tail, hd)
  defp find_max([hd | tail], _), do: find_max(tail, hd)

  @doc """
  Find the minimum of a list

  ## Example
      iex> Fxnk.Math.min([1337, 42, 23])
      23
  """
  @spec min([...]) :: any
  def min([hd | _] = args) do
    find_min(args, hd)
  end

  defp find_min([hd | []], min) when hd > min, do: min
  defp find_min([hd | []], min) when hd < min, do: hd
  defp find_min([hd | tail], min) when hd > min, do: find_min(tail, min)
  defp find_min([hd | tail], min) when hd < min, do: find_min(tail, hd)
  defp find_min([hd | tail], _), do: find_min(tail, hd)

  @doc """
  Add two numbers together

  ## Example
      iex> Fxnk.Math.add(1, 2)
      3
  """
  @spec add(number, number) :: number
  def add(a, b) when is_number(a) and is_number(b) do
    a + b
  end

  @doc """
  Curried `Add/2`

  ## Example
      iex> addOne = Fxnk.Math.add(1)
      iex> addOne.(2)
      3
  """
  @spec add(number) :: function()
  def add(n) when is_number(n) do
    curry(fn arg -> arg + n end)
  end

  @doc """
  Subtract the second argument from the first.

  ## Examples
      iex> Fxnk.Math.subtract(5, 1)
      4
  """
  @spec subtract(number, number) :: number
  def subtract(a, b) when is_number(a) and is_number(b) do
    a - b
  end

  @doc """
  Curried `subtract/2`

  ## Examples
      iex> minusOne = Fxnk.Math.subtract(1)
      iex> minusOne.(5)
      4
  """
  @spec subtract(number) :: function()
  def subtract(n) when is_number(n) do
    curry(fn arg -> arg - n end)
  end

  @doc """
  Division.

  divide(a, b) == a / b

  ## Examples
    iex(1)> Fxnk.Math.divide(1, 4)
    0.25
  """
  @spec divide(number, number) :: float
  def divide(a, b) when is_number(a) and is_number(b) do
    a / b
  end

  @doc """
  Curried `divide`

  ## Examples
      iex> recip = Fxnk.Math.divide(1)
      iex> recip.(4)
      0.25
  """
  @spec divide(number) :: function()
  def divide(n) when is_number(n) do
    curry(fn arg -> n / arg end)
  end

  @doc """
  Multiplication

  multiply(a, b) == a * b

  ## Examples
      iex> Fxnk.Math.multiply(10, 10)
      100
  """
  @spec multiply(number, number) :: number
  def multiply(a, b) when is_number(a) and is_number(b) do
    a * b
  end

  @doc """
  Curried `multiply/2`

  ## Examples
      iex> timesTen = Fxnk.Math.multiply(10)
      iex> timesTen.(10)
      100
  """
  @spec multiply(number) :: function()
  def multiply(n) when is_number(n) do
    curry(fn arg -> n * arg end)
  end

  @doc """
  Averages a list of numbers, returns a float.

  ## Examples
      iex> Fxnk.Math.avg([1,4,3,2,5])
      3.0
  """
  @spec avg([number, ...]) :: float
  def avg([hd | tail] = list) when is_list(list) do
    avg(tail, hd, 1)
  end

  defp avg([hd | []], n, len), do: (hd + n) / inc(len)
  defp avg([hd | tl], n, len), do: avg(tl, hd + n, inc(len))

  @spec negate(number) :: number
  @doc """
  Multiply a number times -1.

  ## Examples
    iex> Fxnk.Math.negate(100)
    -100
    iex> Fxnk.Math.negate(-100)
    100
  """
  def negate(n) do
    n * -1
  end

  @doc """
  Increment a number

  ## Example
      iex> Fxnk.Math.inc(1)
      2
  """
  @spec inc(integer) :: integer
  def inc(n) when is_integer(n) do
    n + 1
  end

  @doc """
  Decrement a number

  ## Example
      iex> Fxnk.Math.dec(1)
      0
  """
  @spec dec(integer) :: integer
  def dec(n) when is_integer(n) do
    n - 1
  end
end

defmodule Fxnk.Logic do
  @moduledoc """
  `Fxnk.Logic` are functions for dealing with booleans.
  """
  import Fxnk.Functions, only: [curry: 1]

  @doc """
  Curried `and?/2`.

  ## Examples
      iex> isTwo? = Fxnk.Logic.and?(2)
      iex> isTwo?.(2)
      true
      iex> isTwo?.(3)
      false
  """
  @spec and?(any) :: fun
  def and?(x) do
    curry(fn y -> and?(x, y) end)
  end

  @doc """
  `and?` returns true if both inputs are the same, opposite of `is_not/2`.

  ## Examples
      iex> Fxnk.Logic.and?(2, 2)
      true
      iex> Fxnk.Logic.and?("hello", "world")
      false
  """
  @spec and?(any, any) :: boolean
  def and?(x, x), do: true
  def and?(_, _), do: false

  @doc """
  Curried `both?/3`.

  ## Examples
      iex> gt10lt20? = Fxnk.Logic.both?(fn x -> x > 10 end, fn x -> x < 20 end)
      iex> gt10lt20?.(15)
      true
      iex> gt10lt20?.(30)
      false
  """
  @spec both?(function(), function()) :: fun
  def both?(func1, func2) do
    curry(fn input -> both?(input, func1, func2) end)
  end

  @doc """
  `both?/3` takes an input and two predicate functions, returning true if both functions
  are true when passed the input.

  ## Examples
      iex> Fxnk.Logic.both?(15, fn x -> x > 10 end, fn x -> x < 20 end)
      true
      iex> Fxnk.Logic.both?(30, fn x -> x > 10 end, fn x -> x < 20 end)
      false
  """
  @spec both?(function(), function(), any) :: boolean
  def both?(input, func1, func2) do
    func1.(input) && func2.(input)
  end

  @doc """
  `complement/1` returns the opposite of the boolean passed to it.

  ## Examples
      iex> Fxnk.Logic.complement(true)
      false
      iex> Fxnk.Logic.complement(false)
      true
  """
  @spec complement(boolean) :: boolean
  def complement(bool), do: !bool

  @doc """
  Curried `default_to/2`

  ## Examples
      iex> defaultTo42 = Fxnk.Logic.default_to(42)
      iex> defaultTo42.(false)
      42
      iex> defaultTo42.(nil)
      42
      iex> defaultTo42.("thanks for all the fish")
      "thanks for all the fish"
  """
  @spec default_to(any) :: fun
  def default_to(x), do: curry(fn y -> default_to(y, x) end)

  @doc """
  `default_to/2` takes two values and returns the right side value if the left side is `false` or `nil`

  ## Examples
      iex> false |> Fxnk.Logic.default_to(42)
      42
      iex> nil |> Fxnk.Logic.default_to(42)
      42
      iex> "hello, world" |> Fxnk.Logic.default_to(42)
      "hello, world"
  """
  @spec default_to(any, any) :: any
  def default_to(x, y) do
    case x do
      false -> y
      nil -> y
      _ -> x
    end
  end

  @doc """
  Curried `either/3`

  ## Examples
      iex> lt10orGt30? = Fxnk.Logic.either?(fn x -> x < 10 end, fn x -> x > 30 end)
      iex> lt10orGt30?.(5)
      true
      iex> lt10orGt30?.(15)
      false
  """
  @spec either?(function(), function()) :: fun
  def either?(func1, func2) do
    curry(fn input -> either?(input, func1, func2) end)
  end

  @doc """
  `either?/3` takes an input and two predicate functions and returns true if either predicate is true.

  ## Examples
      iex> Fxnk.Logic.either?(5, fn x -> x < 10 end, fn x -> x > 30 end)
      true
      iex> Fxnk.Logic.either?(15, fn x -> x < 10 end, fn x -> x > 30 end)
      false
  """
  @spec either?(any, function(), function()) :: any
  def either?(input, func1, func2) do
    func1.(input) || func2.(input)
  end

  @doc """
  `is_empty/1` returns true if passed an empty `Map` or `List`.

  ## Examples
      iex> Fxnk.Logic.is_empty([])
      true
      iex> Fxnk.Logic.is_empty(%{})
      true
      iex> Fxnk.Logic.is_empty([1,1,2,3,5,8])
      false
  """
  @spec is_empty(any) :: boolean
  def is_empty([]), do: true
  def is_empty(%{}), do: true
  def is_empty(_), do: false

  @doc """
  Curried `is_not?/2`

  ## Examples
      iex> isNotThree = Fxnk.Logic.is_not?(3)
      iex> isNotThree.(3)
      false
      iex> isNotThree.(4)
      true
  """
  @spec is_not?(any) :: fun
  def is_not?(x), do: curry(fn y -> is_not?(x, y) end)

  @doc """
  `is_not/3` returns true if both inputs are not the same, opposite of `and?/2`

  ## Examples
      iex> Fxnk.Logic.is_not?(3, 3)
      false
      iex> Fxnk.Logic.is_not?(3, 4)
      true
  """
  @spec is_not?(any, any) :: boolean
  def is_not?(x, x), do: false
  def is_not?(_, _), do: true

  @doc """
  Curried `or/2`

  ## Examples
    iex> willBeTrue = Fxnk.Logic.or?(true)
    iex> willBeTrue.(false)
    true

  """
  @spec or?(any) :: fun
  def or?(x), do: curry(fn y -> or?(x, y) end)

  @doc """
  `or/2` returns true if one or both of its arguments are true.

  ## Examples
      iex> Fxnk.Logic.or?(true, false)
      true
      iex> Fxnk.Logic.or?(true, true)
      true
      iex> Fxnk.Logic.or?(false, false)
      false
  """
  @spec or?(any, any) :: boolean
  def or?(true, _), do: true
  def or?(_, true), do: true
  def or?(_, _), do: false
end

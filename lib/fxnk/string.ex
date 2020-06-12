defmodule Fxnk.String do
  @moduledoc """
  Functions for working with strings.
  """

  @doc """
  Concatenate two strings.

  ## Example
      iex> Fxnk.String.concat("hello", "world")
      "helloworld"
  """
  @spec concat(String.t(), String.t()) :: String.t()
  def concat(str1, str2) do
    str1 <> str2
  end

  @doc """
  Joins a list of strings together with a seperator.

  ## Example
      iex> Fxnk.String.join(["a", "b", "c"], "|")
      "a|b|c"
      iex> Fxnk.String.join(["foo", "bar", "baz"], " is better than ")
      "foo is better than bar is better than baz"
  """
  @spec join([String.t(), ...], String.t()) :: String.t()
  def join(list, seperator) do
    list
    |> Enum.intersperse(seperator)
    |> List.to_string()
  end
end

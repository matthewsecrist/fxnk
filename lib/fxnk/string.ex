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
end

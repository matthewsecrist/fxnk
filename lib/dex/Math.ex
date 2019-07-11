defmodule Fxnk.Math do
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
end

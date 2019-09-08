defmodule Fxnk.MathTest do
  use ExUnit.Case
  doctest Fxnk.Math

  import Fxnk.Math

  test "finds the maximum of a list" do
    assert 3 = max([1, 2, 3])
    assert 1 = max([1])
  end
end

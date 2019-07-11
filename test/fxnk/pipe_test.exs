defmodule PipeTest do
  use ExUnit.Case
  import Fxnk.Pipe

  test "curried pipe works with a list" do
    reverseSort = pipe([&Enum.sort/1, &Enum.reverse/1])
    sorted = reverseSort.([1, 3, 5, 7, 6, 4, 2])
    assert sorted == [7, 6, 5, 4, 3, 2, 1]
  end

  test "pipeable compose" do
    sorted = pipe([1, 3, 5, 7, 6, 4, 2], [&Enum.sort/1, &Enum.reverse/1])
    assert sorted == [7, 6, 5, 4, 3, 2, 1]
  end
end

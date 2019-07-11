defmodule ComposeTest do
  use ExUnit.Case
  import Fxnk.Compose

  test "curried compose works with a list" do
    reverseSort = compose([&Enum.reverse/1, &Enum.sort/1])
    sorted = reverseSort.([1, 3, 5, 7, 6, 4, 2])
    assert sorted == [7, 6, 5, 4, 3, 2, 1]
  end

  test "pipeable compose" do
    sorted = compose([1, 3, 5, 7, 6, 4, 2], [&Enum.reverse/1, &Enum.sort/1])
    assert sorted == [7, 6, 5, 4, 3, 2, 1]
  end
end

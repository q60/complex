defmodule ComplexTest do
  use ExUnit.Case
  doctest Complex

  test "greets the world" do
    assert Complex.hello() == :world
  end
end

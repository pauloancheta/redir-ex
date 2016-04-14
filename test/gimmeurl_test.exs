defmodule RedirTest do
  use ExUnit.Case
  doctest Redir

  # to disable this test, run mix test --exclude disabled
  @tag disabled: true
  test "the truth" do
    assert 1 == 1
  end

  # To run just this test, run mix test --only priority
  @tag priority: true
  test "run this test" do
    assert 2 == 2
  end

end

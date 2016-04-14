defmodule RedirTest do
  use ExUnit.Case
  doctest Redir
  Redir.start

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

  test "not sure" do
    url = "http://google.ca"
    assert Redir.final_url(url) == "http://www.google.ca"
  end

end

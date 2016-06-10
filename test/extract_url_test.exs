defmodule ExtractUrlTest do
  use ExUnit.Case
  doctest ExtractUrl

  test "valid uri" do
    uri = ExtractUrl.call("http://www.google.com/awesome_page/?query=lol lol")
    assert uri.authority == "www.google.com"
    assert uri.scheme == "http"
    assert String.match?(uri.path, ~r/awesome_page/)
    assert uri.query == "query=lol%20lol"
  end

  test "invalid uri" do
    assert_raise UriError.InvalidSchemeError, "Invalid URI scheme", fn ->
      ExtractUrl.call("something http://www.google.com")
    end

    assert_raise UriError.InvalidSchemeError, "Invalid URI scheme", fn ->
      ExtractUrl.call("www.google.com")
    end
  end
end

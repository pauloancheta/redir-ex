defmodule RedirTest do
  use ExUnit.Case
  doctest Redir

  test "return url from bitly" do
    Redir.start
    uri = "http://bit.ly/1xLNtmk"
    assert Redir.final_url(uri) == "http://lucumr.pocoo.org/2014/10/1/a-fresh-look-at-rust/?utm_content=buffer4cbf8&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer"
  end

  test "guard against 400's" do
    Redir.start
    uri = "http://httpmock.herokuapp.com/response/403"
    assert Redir.final_url(uri) == "Not found!"

    uri = "http://httpmock.herokuapp.com/response/404"
    assert Redir.final_url(uri) == "Not found!"
  end

  test "guard against server error" do
    Redir.start
    uri = "http://httpmock.herokuapp.com/response/500"
    assert Redir.final_url(uri) == "Server error!"
  end

# http => http
# https => http
# http => https
# meta refresh
# redirect with cookie
# infinite redirect

end

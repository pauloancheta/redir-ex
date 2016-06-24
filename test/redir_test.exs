defmodule RedirTest do
  use ExUnit.Case
  doctest Redir

  test "return url from bitly" do
    Redir.start
    uri = "http://bit.ly/1xLNtmk"
    assert Redir.final_url(uri) == { :ok, "http://lucumr.pocoo.org/2014/10/1/a-fresh-look-at-rust/?utm_content=buffer4cbf8&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer" }
  end

  test "guard against 400's" do
    Redir.start
    uri = "http://httpmock.herokuapp.com/response/403"
    assert Redir.final_url(uri) == { :error, "Error 403" }

    uri = "http://httpmock.herokuapp.com/response/404"
    assert Redir.final_url(uri) == { :error, "Error 404" }
  end

  test "guard against server error" do
    Redir.start
    uri = "http://httpmock.herokuapp.com/response/500"
    assert Redir.final_url(uri) == { :error, "Error 500" }
  end

  test "meta refresh" do
    Redir.start
    uri = "http://httpmock.herokuapp.com/redirect-with-meta?to=http://brewhouse.io"
    assert Redir.final_url(uri) == { :ok, "http://brewhouse.io" }
  end

  test "301 with location without a host or scheme" do
    Redir.start
    uri = "https://www.pagerduty.com/lp/saas-on-the-line/"
    assert Redir.final_url(uri) == { :ok, "https://www.pagerduty.com/lp/d/saas-on-the-line/" }
  end

  test "with bad request" do
    Redir.start
    uri = "http://talk.buildinbombay.com/t/build-in-bombay-s-aua-with-super"
    assert Redir.final_url(uri) == { :error, :bad_request }
  end

  test "invalid character encoding" do
    Redir.start
    uri = "http://www.demotivateur.fr/article-buzz/ce-coupe-decide-de-tout-quitter-d-acheter-un-voilier-et-de-faire-le-tour-du-monde-avec-leur-chat-le-reve--2762"
    assert Redir.final_url(uri) == { :ok, uri }
  end

# http => http
# https => http
# http => https
# meta refresh
# redirect with cookie
# infinite redirect

end

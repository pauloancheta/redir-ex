defmodule Redir do
  use HTTPoison.Base

  def final_url(url) do
    parse_url(url)
  end

  defp parse_url(url) do
    case get(url) do
      {:ok, %HTTPoison.Response{status_code: status, headers: headers, body: body}} ->
        response(url, status, headers, body)
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  defp response(url, status, headers, body) do
    case status do
      200 -> url;
      302 -> get_url_from_header(headers);
      301 -> get_url_from_header(headers);
      404 -> IO.puts "NOT FOUND!"
    end
  end

  defp get_url_from_header(headers) do
    headers
    |> List.keyfind("Location", 0)
    |> elem(1)
    |> parse_url
  end
end

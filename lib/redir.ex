defmodule Redir do
  use HTTPoison.Base

  def final_url(url) do
    url
    |> ExtractUrl.call
    |> URI.to_string
    |> parse_url
  end

  defp parse_url(url) do
    case get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        cond do
          contains_meta_refresh?(body) -> url_with_meta(body)
          true -> url
        end
      {:ok, %HTTPoison.Response{status_code: 500}} ->
        "Server error!"
      {:ok, %HTTPoison.Response{status_code: 302, headers: headers}} ->
        get_url_from_header(headers)
      {:ok, %HTTPoison.Response{status_code: 301, headers: headers}} ->
        get_url_from_header(headers)
      {:ok, %HTTPoison.Response{status_code: _not_found}} ->
        "Not found!"
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  defp get_url_from_header(headers) do
    headers
    |> List.keyfind("Location", 0)
    |> elem(1)
    |> parse_url
  end

  defp contains_meta_refresh?(body) do
    body
    |> Floki.attribute("meta", "http-equiv")
    |> List.to_string
    |> String.contains?("refresh")
  end

  defp url_with_meta(body) do
    body
    |> Floki.attribute("meta", "content")
    |> List.last()
    |> parsed_meta
  end

  defp parsed_meta(content) do
    content
    |> String.split("=")
    |> List.last
  end
end

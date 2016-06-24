defmodule Redir do
  use HTTPoison.Base

  # Returns:
  #   { :ok, "http://....." }
  #   { :error, "Error message" }
  def final_url(url) do
    url
    |> ExtractUrl.call
    |> URI.to_string
    |> parse_url
  end

  defp parse_url(url) do
    try do
      { :ok, response } = get(url)
      process_response(response.status_code, url, response.headers, response.body)
     rescue
       # HTTPoison fails to catch { :error, :bad_request }
       e in CaseClauseError -> e.term
     end
  end

  defp process_response(200, url, headers, body) do
    if meta_url = extract_meta(body) do
      parse_url(meta_url)
    else
      { :ok, url }
    end
  end

  defp process_response(301, url, headers, body) do
    parse_url(get_url_from_header(url, headers))
  end

  defp process_response(302, url, headers, body) do
    parse_url(get_url_from_header(url, headers))
  end

  defp process_response(code, url, headers, body) do
    { :error, "Error #{code}" }
  end


  defp get_url_from_header(base_url, headers) do
    url = get_location(headers) |> elem(1)
    if !String.contains?(url, "http") do
      ExtractUrl.add_base_url(base_url, url)
    else
      url
    end
  end

  defp get_location(headers) do
    loc = List.keyfind(headers, "Location", 0)
    if loc == nil do
      loc = List.keyfind(headers, "location", 0)
    end
    loc
  end

  defp extract_meta(body) do
    cond do
      contains_meta_refresh?(body) -> url_with_meta(body)
      true -> nil
    end
  end

  defp contains_meta_refresh?(body) do
    meta_http_equiv = body
    |> clean_body
    |> Floki.attribute("meta", "http-equiv")
    |> List.to_string

    meta_content = body
    |> clean_body
    |> Floki.attribute("meta", "content")
    |> List.to_string

    String.contains?(meta_http_equiv, "refresh") && String.contains?(meta_content, "url")
  end

  defp clean_body(body) do
    String.chunk(body, :printable)
    |> Enum.filter(&(String.valid?(&1)))
    |> List.to_string
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

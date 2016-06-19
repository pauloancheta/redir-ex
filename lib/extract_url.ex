defmodule ExtractUrl do
  def call(url) do
    url
    |> String.lstrip
    |> URI.encode
    |> URI.parse
    |> prune
  end

  def add_base_url(base_url, url) do
    base = URI.parse(base_url)
    "#{base.scheme}://#{base.host}#{url}"
  end

  defp prune(uri) do
    cond do
      has_invalid_scheme(uri.scheme) -> raise UriError.InvalidSchemeError
      true -> uri
    end
  end

  defp has_invalid_scheme(scheme) when scheme == "http", do: false
  defp has_invalid_scheme(scheme) when scheme == "https", do: false
  defp has_invalid_scheme(_), do: true
end

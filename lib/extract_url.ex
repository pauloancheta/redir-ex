defmodule ExtractUrl do
  require IEx

  def call(url) do
    url
    |> URI.parse
    |> prune
  end

  defp prune(uri) do
    cond do
      is_nil(uri.authority)   -> raise "Invalid URI authority"
      true -> uri
    end
  end
end

defmodule Portfolio.Credly do
  def fetch_data do
    headers = [{"Accept", "application/json"}]

    case HTTPoison.get(
           "https://www.credly.com/users/tristan-jahnke/badges",
           headers
         ) do
      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body: body
       }} ->
        {:ok, Jason.decode!(body)}

      {:error, _} ->
        {:error, "Failed to get Credly badges."}
    end
  end
end

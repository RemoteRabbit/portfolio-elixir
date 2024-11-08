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
        data = Jason.decode!(body)
        filtered_data = filter_expired_badges(data["data"])
        {:ok, %{"data" => filtered_data}}

      {:error, _} ->
        {:error, "Failed to get Credly badges."}
    end
  end

  defp filter_expired_badges(badges) do
    Enum.filter(badges, fn badge ->
      expires_at = badge["expires_at"]

      if expires_at == nil or
           NaiveDateTime.compare(NaiveDateTime.from_iso8601!(expires_at), NaiveDateTime.utc_now()) ==
             :gt do
        true
      else
        false
      end
    end)
  end
end

defmodule Scrum2000.Trello do

  alias Jason, as: JSON

  @trello_api_endpoint "https://api.trello.com"

  def post_comment_if_new(card_id, message) do
    card_comments = get_comments(card_id)

    if filter_worked_hour(message) not in filter_worked_hours(card_comments) do
      post_comment(card_id, message)
      :ok
    else
      :none
    end
  end

  defp post_comment(card_id, message) do
    api_key = Application.get_env(:scrum2000, :trello_api_key)
    token = Application.get_env(:scrum2000, :trello_token)
    url = "#{@trello_api_endpoint}/1/cards/#{card_id}/actions/comments?text=#{URI.encode(message)}&key=#{api_key}&token=#{token}"

    get_http_provider().post(url, "")
  end

  defp get_comments(card_id) do
    api_key = Application.get_env(:scrum2000, :trello_api_key)
    token = Application.get_env(:scrum2000, :trello_token)
    url = "#{@trello_api_endpoint}/1/cards/#{card_id}/actions?key=#{api_key}&token=#{token}"

    {:ok, %HTTPoison.Response{body: body }} = get_http_provider().get(url)

    body
    |> JSON.decode!
    |> extract_scrums()
  end

  defp filter_worked_hours(comments), do: comments |> Enum.map(&filter_worked_hour/1)
  defp filter_worked_hour(comment), do: Regex.replace(~r/\[[0-9.]*h\]/U, comment, "") |> String.trim

  defp get_http_provider(), do: Process.get(:scrum2000_http_provider, Application.get_env(:scrum2000, :http_provider))

  defp extract_scrums(data), do: data |> Enum.map(&extract_scrum/1) |> Enum.reject(&is_nil/1)
  defp extract_scrum(%{"data" => %{"text" => scrum = "Scrum" <> _}}), do: scrum
  defp extract_scrum(_), do: nil

end

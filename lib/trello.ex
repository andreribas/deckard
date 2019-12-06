defmodule Deckard.Trello do

  alias Jason, as: JSON

  @trello_api_endpoint "https://api.trello.com"

  def post_comment_if_new(card_id, message) do
    card_comments = get_comments(card_id)

    if not is_comment_already_posted?(message, card_comments) do
      post_comment(card_id, message)
      :ok
    else
      :none
    end
  end

  def is_comment_already_posted?(message, card_comments) do
    filter_worked_hour(message) in filter_worked_hours(card_comments)
  end

  defp post_comment(card_id, message) do
    api_key = Application.get_env(:deckard, :trello_api_key)
    token = Application.get_env(:deckard, :trello_token)
    url = "#{@trello_api_endpoint}/1/cards/#{card_id}/actions/comments?text=#{URI.encode(message)}&key=#{api_key}&token=#{token}"

    get_http_provider().post(url, "")
  end

  def get_comments(card_id) do
    api_key = Application.get_env(:deckard, :trello_api_key)
    token = Application.get_env(:deckard, :trello_token)
    url = "#{@trello_api_endpoint}/1/cards/#{card_id}/actions?key=#{api_key}&token=#{token}"

    {:ok, %HTTPoison.Response{body: body }} = get_http_provider().get(url)

    body
    |> process_body(card_id)
  end

  defp process_body(_body = "invalid id", card_id) do
    IO.puts("A pull request with an invalid trello card id found. The invalid is #{card_id}")
    []
  end

  defp process_body(body, _) do
    body
    |> JSON.decode!
    |> extract_scrums()
  end

  defp filter_worked_hours(comments), do: comments |> Enum.map(&filter_worked_hour/1)
  defp filter_worked_hour(comment), do: Regex.replace(~r/\[[0-9.]*h\]/U, comment, "") |> String.trim

  defp get_http_provider(), do: Process.get(:deckard_http_provider, Application.get_env(:deckard, :http_provider))

  defp extract_scrums(data), do: data |> Enum.map(&extract_scrum/1) |> Enum.reject(&is_nil/1)
  defp extract_scrum(%{"data" => %{"text" => scrum = "Scrum" <> _}}), do: scrum
  defp extract_scrum(_), do: nil

end

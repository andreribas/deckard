defmodule Deckard.TrelloTest do
  use ExUnit.Case

  alias Deckard.Trello

  test "post a new scrum" do
    assert :ok == Trello.post_comment_if_new("VALID_CARD_ID", "Scrum (10.19) [2h] Sample message")
  end

  test "post an existing scrum, should not post it again" do
    assert :none == Trello.post_comment_if_new("VALID_CARD_ID", "Scrum (10.18) [2h] Sample message")
  end

  setup_all do
    defmodule MockHttp do
      alias Jason, as: JSON
      def get(_), do: response([%{"data" => %{"text" => "Scrum (10.18) [2h] Sample message"}}])
      def post(_, _), do: nil
      defp response(body), do: {:ok, %HTTPoison.Response{body: JSON.encode!(body)}}
    end

    :ok
  end

  setup do
    Process.put(:deckard_http_provider, Deckard.TrelloTest.MockHttp)
    :ok
  end
end

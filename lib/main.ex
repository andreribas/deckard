defmodule Deckard.Main do

  alias Deckard.Github
  alias Deckard.Scrum
  alias Deckard.Trello
  alias Deckard.PullRequest

  def execute(start_date, end_date) do
    org_name = "ebanx"

    summary = Github.get_pull_requests(org_name, start_date, end_date)
    |> Scrum.build_scrum_summary()

    summary |> Scrum.print_scrum_summary()
    continue = IO.gets("yes or no? ") |> String.trim()

    if continue == "yes" do
      IO.puts("continuing")
      summary
      |> Enum.map(&post_to_trello/1)
      :ok
    else
      IO.puts("aborting")
      :none
    end
  end

  defp post_to_trello(%PullRequest{trello_card: trello_card, scrum_message: scrum_message}) do
    IO.puts("Posting into card '#{trello_card}, message '#{scrum_message}''")
    :ok = Trello.post_comment_if_new(trello_card, scrum_message)
  end

end

defmodule Scrum2000.Main do

  alias Scrum2000.Github
  alias Scrum2000.Scrum
  alias Scrum2000.Trello
  alias Scrum2000.PullRequest

  def execute() do
    org_name = "ebanx"
    start_date = "2019-10-21"
    end_date = "2019-10-25"

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

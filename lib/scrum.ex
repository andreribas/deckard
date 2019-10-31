defmodule Scrum2000.Scrum do

  alias Scrum2000.PullRequest

  def build_scrum_summary(pull_requests) do
    pull_requests
    |> Enum.group_by(&by_date/1)
    |> Enum.map(&fill_worktimes/1)
    |> Enum.flat_map(fn {_, pull_requests} -> pull_requests end)
    |> Enum.map(&fill_scrum_message/1)
  end

  def print_scrum_summary(pull_requests) do
    pull_requests
    |> Enum.group_by(&by_trello_card/1, fn %PullRequest{scrum_message: scrum_message} -> " - #{scrum_message}" end)
    |> Enum.map(&build_scrum_summary_message/1)
    |> Enum.join("\n")
    |> IO.puts
  end

  defp build_scrum_summary_message({trello_card, pull_requests}) do
    pull_requests
    |> Enum.join("\n")
    |> String.replace_prefix("", "== #{trello_card} ==\n")
  end

  defp by_date(%PullRequest{datetime: datetime}), do: format_date(datetime)
  defp by_trello_card(%PullRequest{trello_card: trello_card}), do: "https://trello.com/c/#{trello_card}"
  defp build_scrum_string(%PullRequest{title: title, datetime: datetime, work_time: work_time}) do
    "Scrum (#{format_date(datetime)}) [#{format_worktime(work_time)}h]: #{title}"
  end

  defp format_date(datetime) do
    date = Scrum2000.Utils.date_from_iso8601_datetime(datetime)
    "#{date.month}.#{date.day}"
  end

  defp format_worktime(work_time) do
    work_time
    |> Float.round(1)
    |> Float.to_string()
  end

  defp fill_worktimes({date, pull_requests}) do
    task_worktime = get_worked_hours() / Enum.count(pull_requests)

    pull_requests = pull_requests
    |> Enum.map(&fill_worktime(&1, task_worktime))

    {date, pull_requests}
  end

  defp fill_scrum_message(pull_request) do
    %PullRequest{pull_request | scrum_message: build_scrum_string(pull_request)}
  end

  defp get_worked_hours, do: Process.get(:scrum2000_worked_hours, Application.get_env(:scrum2000, :worked_hours)).()

  defp fill_worktime(pull_request, task_worktime), do: %PullRequest{pull_request | work_time: task_worktime}

end
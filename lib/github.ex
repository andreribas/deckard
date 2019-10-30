defmodule Scrum2000.Github do

  alias Scrum2000.PullRequest
  alias Scrum2000.Utils
  alias Jason, as: JSON

  @github_api_endpoint "https://api.github.com/graphql"
  @query ~s"""
  query {
    viewer {
      pullRequests (first: 100, orderBy: {field: CREATED_AT, direction: DESC}) {
        nodes {
          baseRepository {
            name
            owner {
              login
            }
          }
          createdAt
          title
          author { login }
        }
      }
    }
  }
  """

  def get_pull_requests(org_name, start_date, end_date) do
    get_http_provider().post(@github_api_endpoint, build_query_body(), get_headers())
    |> extract_body
    |> JSON.decode!
    |> extract_nodes
    |> Enum.map(&to_pull_requests/1)
    |> Enum.filter(&is_valid_date?(&1, start_date, end_date))
    |> Enum.filter(&is_org_name?(&1, org_name))
  end

  defp get_http_provider(), do: Process.get(:scrum2000_http_provider, Application.get_env(:scrum2000, :http_provider))
  defp build_query_body(), do: JSON.encode!(%{"query" => @query})
  defp get_headers(), do: ["Authorization": "Basic #{get_credentials()}"]
  defp get_credentials(), do: Application.get_env(:scrum2000, :github_basic_auth) |> Base.encode64()
  defp extract_body({:ok, %HTTPoison.Response{body: body}}), do: body
  defp extract_nodes(%{"data" => %{"viewer" => %{"pullRequests" => %{"nodes" => nodes}}}}), do: nodes

  defp to_pull_requests(%{
    "author" => %{"login" => author},
    "baseRepository" => %{
      "name" => repo,
      "owner" => %{"login" => org_name}
    },
    "createdAt" => datetime,
    "title" => raw_title
  }) do
    %PullRequest{
      raw_title: raw_title,
      title: remove_trello_card_from_title(raw_title),
      trello_card: trello_card_from_title(raw_title),
      author: author,
      repo: repo,
      org_name: org_name,
      datetime: datetime,
    }
  end


  defp trello_card_from_title(title) do
    Regex.named_captures(~r/\[t[-:](?<trello_card>.*)\]/U, title)
    |> extract_trello_card()
  end

  defp extract_trello_card(%{"trello_card" => trello_card}), do: trello_card
  defp extract_trello_card(_), do: ""

  defp remove_trello_card_from_title(title) do
    Regex.replace(~r/\[t[-:].*\]/U, title, "")
    |> String.trim
  end

  defp is_org_name?(%PullRequest{org_name: org_name}, org_name), do: true
  defp is_org_name?(_, _), do: false

  defp is_valid_date?(%PullRequest{datetime: datetime}, start_date, end_date) do
    Utils.is_iso8601_date_between_iso8601_dates?(datetime, start_date, end_date)
  end

end

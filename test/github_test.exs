defmodule Scrum2000.GithubTest do
  use ExUnit.Case

  alias Scrum2000.Github
  alias Scrum2000.PullRequest

  test "valid github response is properly parsed" do
    expected_result = [
      %PullRequest{
        author: "AUTHOR_NAME",
        datetime: "2019-10-23T14:32:51Z",
        org_name: "ORG_NAME",
        raw_title: "[t-TRELLO_HASH] PULL_REQUEST_TITLE",
        repo: "REPO_NAME",
        title: "PULL_REQUEST_TITLE",
        trello_card: "TRELLO_HASH",
        work_time: nil
      }
    ]
    assert expected_result == Github.get_pull_requests("ORG_NAME", "2019-10-21", "2019-10-25")
  end

  test "different org_name should not be present in the output" do
    assert [] == Github.get_pull_requests("OTHER_ORG_NAME", "2019-10-21", "2019-10-25")
  end

  test "date not in range should not be present in the output" do
    assert [] == Github.get_pull_requests("ORG_NAME", "2019-10-21", "2019-10-22")
    assert [] == Github.get_pull_requests("ORG_NAME", "2019-10-24", "2019-10-25")
  end

  setup_all do
    defmodule MockHttp do

      alias Jason, as: JSON

      def post(_, _, _) do
        body = %{
          "data" => %{
            "viewer" => %{
              "pullRequests" => %{
                "nodes" => [
                  %{
                    "author" => %{
                      "login" => "AUTHOR_NAME"
                    },
                    "baseRepository" => %{
                      "name" => "REPO_NAME",
                      "owner" => %{
                        "login" => "ORG_NAME"
                      }
                    },
                    "createdAt" => "2019-10-23T14:32:51Z",
                    "title" => "[t-TRELLO_HASH] PULL_REQUEST_TITLE"
                  }
                ]
              }
            }
          }
        }
        {:ok, %HTTPoison.Response{body: JSON.encode!(body)}}
      end
    end

    :ok
  end

  setup do
    Process.put(:scrum2000_http_provider, Scrum2000.GithubTest.MockHttp)
    :ok
  end


end

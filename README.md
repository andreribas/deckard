# Deckard

> "Stay awhile and listen!!" - Deckard Cain
>
> ![deckard-cain](https://user-images.githubusercontent.com/605008/67953228-761d2600-fbcd-11e9-8f77-67d52401e377.png)


A CLI tool built to automate daily scrum reporting at EBANX.

## The problem it solved

Every day, as an individual contributor, I needed to report on my own progress — summarizing the week's pull requests and posting updates to the corresponding Trello cards. Doing this manually meant cross-referencing GitHub and Trello by hand, every single day.

Deckard automated the full loop: fetch PRs from a GitHub org for a given date range, build a formatted scrum summary, let you review it, then post the comments directly to the right Trello cards in one shot.

## How it worked

```elixir
Deckard.Main.execute("2019-11-04", "2019-11-08")
```

1. Fetches all pull requests from the GitHub org within the date range
2. Builds a human-readable scrum summary per PR
3. Prints the summary and asks for confirmation
4. If confirmed, posts each message as a comment on the corresponding Trello card

The confirmation step was intentional — fast to run, but always human-reviewed before posting.

## Why Elixir

I was learning Elixir at the time and this was a good excuse to use it on a real problem. The pipeline-style data flow (`|>`) maps naturally to the fetch → transform → output pattern here.

## Context

This was a personal productivity tool, not a polished product. Today the same workflow would be a few lines wired into an MCP server. But it did the job well for its time, and building it was faster than doing the reporting manually for one more week.

## Setup

Copy `config.secret.sample.exs` to `config.secret.exs` and fill in your credentials:

- **GitHub token**: https://github.com/settings/tokens — requires `repo` permissions
- **Trello key + token**: https://trello.com/app-key

Then run:

```bash
./run.sh
```

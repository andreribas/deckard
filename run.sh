#!/usr/bin/env bash

mix deps.get
mix compile
iex -r "do_scrum.exs" -S mix

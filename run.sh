#!/usr/bin/env bash

mix deps.get
mix compile
iex -S mix

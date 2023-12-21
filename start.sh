#!/bin/bash

if ! [ -x "$(command -v ruby)" ]; then
  echo "Error: Ruby is not installed." >&2
  exit 1
fi

# export SOME_VAR=value

ruby main.rb "$@"

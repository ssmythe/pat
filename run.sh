#!/usr/bin/env bash

echo "Building pat..."
go build

echo "Running BATS..."
if [ -z "$1" ]; then
  bats --tap test/bats
elif [ "$1" = "github" ]; then
  bats --tap test/bats/*_github.bats
elif [ "$1" = "bitbucket" ]; then
  bats --tap test/bats/*_bitbucket.bats
elif [ "$1" = "local" ]; then
  bats --tap test/bats/*_local.bats
else
  bats --tap test/bats/scenario_$1_$2.bats
fi

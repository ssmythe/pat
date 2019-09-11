#!/usr/bin/env bash

echo "Building pat..."
go build

echo "Setting up sandbox"
source test/bats/test_helper.bash
setup
seed_local_templates

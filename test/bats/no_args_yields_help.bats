#!/usr/bin/env bats

load test_helper

@test "no_args_yields_help" {
  run bash -c "${APP}"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Usage: pat [OPTIONS]" ]
}

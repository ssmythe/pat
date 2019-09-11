#!/usr/bin/env bats

load test_helper

@test "setup sandbox" {
  [ -d "${SANDBOX}" ]
}

@test "teardown sandbox" {
  teardown
  [ ! -d "${SANDBOX}" ]
}

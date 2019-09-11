#!/usr/bin/env bats

load test_helper

@test "verify difflist 001" {
  seed_hello_world
  difflist test/difflists/001.txt
}

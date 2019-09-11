#!/usr/bin/env bats

load test_helper

@test "scenario_013_local" {
  seed_local_templates

  run bash -c "${APP} --commit --spec test/specs/local/013.yml --work ${SANDBOX} --local"
  [ "$status" -eq 0 ]
  difflist test/difflists/013.txt
}

#!/usr/bin/env bats

load test_helper

@test "scenario_018_local" {
  seed_local_templates

  run bash -c "${APP} --commit --spec test/specs/local/018.yml --work ${SANDBOX} --local --gomplate-args=\"-d vars=test/datasource/018.yml\""
  [ "$status" -eq 0 ]
  difflist test/difflists/018.txt
}

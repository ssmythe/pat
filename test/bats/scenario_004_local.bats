#!/usr/bin/env bats

load test_helper

@test "scenario_004_local" {
  seed_local_templates

  run bash -c "${APP} --commit --spec test/specs/local/001.yml --work ${SANDBOX} --local"
  [ "$status" -eq 0 ]
  difflist test/difflists/001.txt

  run bash -c "${APP} --commit --spec test/specs/local/004.yml --work ${SANDBOX} --local --force=*"
  [ "$status" -eq 0 ]
  difflist test/difflists/004.txt
}

#!/usr/bin/env bats

load test_helper

@test "scenario_008_local" {
  seed_local_templates

  run bash -c "${APP} --commit --spec test/specs/local/005.yml --work ${SANDBOX} --local"
  [ "$status" -eq 0 ]
  difflist test/difflists/005.txt

  run bash -c "${APP} --commit --spec test/specs/local/008.yml --work ${SANDBOX} --local --force=*"
  [ "$status" -eq 0 ]
  difflist test/difflists/008.txt
}

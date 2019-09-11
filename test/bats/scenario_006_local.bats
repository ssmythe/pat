#!/usr/bin/env bats

load test_helper

@test "scenario_006_local" {
  seed_local_templates

  run bash -c "${APP} --commit --spec test/specs/local/005.yml --work ${SANDBOX} --local"
  [ "$status" -eq 0 ]
  difflist test/difflists/005.txt

  run bash -c "${APP} --commit --spec test/specs/local/006.yml --work ${SANDBOX} --local"
  [ "$status" -eq 0 ]
  difflist test/difflists/006.txt
}

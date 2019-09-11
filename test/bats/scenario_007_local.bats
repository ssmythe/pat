#!/usr/bin/env bats

load test_helper

@test "scenario_007_local" {
  seed_local_templates

  run bash -c "${APP} --commit --spec test/specs/local/005.yml --work ${SANDBOX} --local"
  [ "$status" -eq 0 ]
  difflist test/difflists/005.txt

  run bash -c "${APP} --commit --spec test/specs/local/007.yml --work ${SANDBOX} --local --force hello"
  [ "$status" -eq 0 ]
  difflist test/difflists/007.txt
}

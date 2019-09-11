#!/usr/bin/env bats

load test_helper

@test "scenario_003_local" {
  seed_local_templates

  run bash -c "${APP} --commit --spec test/specs/local/001.yml --work ${SANDBOX} --local"
  [ "$status" -eq 0 ]
  difflist test/difflists/001.txt

  run bash -c "${APP} --commit --spec test/specs/local/003.yml --work ${SANDBOX} --local --force hello"
  [ "$status" -eq 0 ]
  difflist test/difflists/003.txt
}

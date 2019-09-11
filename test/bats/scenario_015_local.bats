#!/usr/bin/env bats

load test_helper

@test "scenario_015_local" {
  seed_local_templates

  run bash -c "${APP} --commit --spec test/specs/local/013.yml --work ${SANDBOX} --local"
  [ "$status" -eq 0 ]
  difflist test/difflists/013.txt

  run bash -c "${APP} --commit --spec test/specs/local/015.yml --work ${SANDBOX} --local --force hello"
  [ "$status" -eq 0 ]
  difflist test/difflists/015.txt
}

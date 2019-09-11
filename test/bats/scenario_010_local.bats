#!/usr/bin/env bats

load test_helper

@test "scenario_010_local" {
  seed_local_templates

  run bash -c "${APP} --commit --spec test/specs/local/009.yml --work ${SANDBOX} --local"
  [ "$status" -eq 0 ]
  difflist test/difflists/009.txt

  run bash -c "${APP} --commit --spec test/specs/local/010.yml --work ${SANDBOX} --local"
  [ "$status" -eq 0 ]
  difflist test/difflists/010.txt
}

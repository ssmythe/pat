#!/usr/bin/env bats

load test_helper

@test "scenario_012_local" {
  seed_local_templates

  run bash -c "${APP} --commit --spec test/specs/local/009.yml --work ${SANDBOX} --local"
  [ "$status" -eq 0 ]
  difflist test/difflists/009.txt

  run bash -c "${APP} --commit --spec test/specs/local/012.yml --work ${SANDBOX} --local --force=*"
  [ "$status" -eq 0 ]
  difflist test/difflists/012.txt
}

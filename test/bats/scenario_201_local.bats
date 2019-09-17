#!/usr/bin/env bats

load test_helper

@test "scenario_201_local" {
  seed_local_templates

  run bash -c "${APP} --commit --spec test/specs/local/201.yml --work ${SANDBOX} --local"
  [ "$status" -eq 0 ]
  [ ! -f ${COMPONENT}/hello.sh ]
}

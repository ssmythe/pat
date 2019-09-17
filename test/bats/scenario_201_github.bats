#!/usr/bin/env bats

load test_helper

@test "scenario_201_github" {
  run bash -c "hub delete ssmythe/pat_test_component -y || true"
  [ "$status" -eq 0 ]

  run bash -c "${APP} --commit --spec test/specs/github/201.yml --work ${SANDBOX}"
  [ "$status" -eq 0 ]
  [ ! -f ${COMPONENT}/hello.sh ]
}

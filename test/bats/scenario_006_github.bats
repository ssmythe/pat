#!/usr/bin/env bats

load test_helper

@test "scenario_006_github" {
  run bash -c "hub delete ssmythe/pat_test_component -y || true"
  [ "$status" -eq 0 ]

  run bash -c "${APP} --commit --spec test/specs/github/005.yml --work ${SANDBOX}"
  [ "$status" -eq 0 ]
  difflist test/difflists/005.txt

  run bash -c "${APP} --commit --spec test/specs/github/006.yml --work ${SANDBOX}"
  [ "$status" -eq 0 ]
  difflist test/difflists/006.txt
}

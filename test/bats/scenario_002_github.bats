#!/usr/bin/env bats

load test_helper

@test "scenario_002_github" {
  run bash -c "hub delete ssmythe/pat_test_component -y || true"
  [ "$status" -eq 0 ]

  run bash -c "${APP} --commit --spec test/specs/github/001.yml --work ${SANDBOX}"
  [ "$status" -eq 0 ]
  difflist test/difflists/001.txt

  run bash -c "${APP} --commit --spec test/specs/github/002.yml --work ${SANDBOX}"
  [ "$status" -eq 0 ]
  difflist test/difflists/002.txt
}

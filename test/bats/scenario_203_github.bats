#!/usr/bin/env bats

load test_helper

@test "scenario_203_github" {
  run bash -c "hub delete ssmythe/pat_test_component -y || true"
  [ "$status" -eq 0 ]

  run bash -c "${APP} --commit --spec test/specs/github/001.yml --work ${SANDBOX}"
  [ "$status" -eq 0 ]
  difflist test/difflists/001.txt

  run bash -c "${APP} --commit --spec test/specs/github/202.yml --work ${SANDBOX} --force=hello"
  [ "$status" -eq 0 ]
  difflist test/difflists/001.txt
}

#!/usr/bin/env bats

load test_helper

@test "scenario_015_github" {
  run bash -c "hub delete ssmythe/pat_test_component -y || true"
  [ "$status" -eq 0 ]

  run bash -c "hub delete ssmythe/pat_test_other -y || true"
  [ "$status" -eq 0 ]

  run bash -c "${APP} --commit --spec test/specs/github/013.yml --work ${SANDBOX}"
  [ "$status" -eq 0 ]
  difflist test/difflists/013.txt

  run bash -c "${APP} --commit --spec test/specs/github/015.yml --work ${SANDBOX} --force hello"
  [ "$status" -eq 0 ]
  difflist test/difflists/015.txt
}

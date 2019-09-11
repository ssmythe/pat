#!/usr/bin/env bats

load test_helper

@test "scenario_010_github" {
  run bash -c "hub delete ssmythe/pat_test_component -y || true"
  [ "$status" -eq 0 ]

  run bash -c "hub delete ssmythe/pat_test_other -y || true"
  [ "$status" -eq 0 ]

  run bash -c "${APP} --commit --spec test/specs/github/009.yml --work ${SANDBOX}"
  [ "$status" -eq 0 ]
  difflist test/difflists/009.txt

  run bash -c "${APP} --commit --spec test/specs/github/010.yml --work ${SANDBOX}"
  [ "$status" -eq 0 ]
  difflist test/difflists/010.txt
}

#!/usr/bin/env bats

load test_helper

@test "scenario_018_github" {
  run bash -c "hub delete ssmythe/pat_test_component -y || true"
  [ "$status" -eq 0 ]

  run bash -c "${APP} --commit --spec test/specs/github/018.yml --work ${SANDBOX} --gomplate-args=\"-d vars=test/datasource/018.yml\""
  [ "$status" -eq 0 ]
  difflist test/difflists/018.txt
}

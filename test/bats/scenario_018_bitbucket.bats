#!/usr/bin/env bats

load test_helper

@test "scenario_018_bitbucket" {
  wipe_component_repo_contents
  teardown
  setup

  run bash -c "${APP} --commit --spec test/specs/bitbucket/018.yml --work ${SANDBOX} --user stevesmythe --gomplate-args=\"-d vars=test/datasource/018.yml\""
  [ "$status" -eq 0 ]
  difflist test/difflists/018.txt
}

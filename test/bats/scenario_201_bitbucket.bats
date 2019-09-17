#!/usr/bin/env bats

load test_helper

@test "scenario_001_bitbucket" {
  wipe_component_repo_contents
  teardown
  setup

  run bash -c "${APP} --commit --spec test/specs/bitbucket/001.yml --work ${SANDBOX} --user stevesmythe"
  [ "$status" -eq 0 ]
  difflist test/difflists/001.txt
}

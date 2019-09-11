#!/usr/bin/env bats

load test_helper

@test "scenario_008_bitbucket" {
  wipe_component_repo_contents
  teardown
  setup

  run bash -c "${APP} --commit --spec test/specs/bitbucket/005.yml --work ${SANDBOX} --user stevesmythe"
  [ "$status" -eq 0 ]
  difflist test/difflists/005.txt

  run bash -c "${APP} --commit --spec test/specs/bitbucket/008.yml --work ${SANDBOX} --user stevesmythe --force=*"
  [ "$status" -eq 0 ]
  difflist test/difflists/008.txt
}

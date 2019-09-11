#!/usr/bin/env bats

load test_helper

@test "scenario_006_bitbucket" {
  wipe_component_repo_contents
  teardown
  setup

  run bash -c "${APP} --commit --spec test/specs/bitbucket/005.yml --work ${SANDBOX} --user stevesmythe"
  [ "$status" -eq 0 ]
  difflist test/difflists/005.txt

  run bash -c "${APP} --commit --spec test/specs/bitbucket/006.yml --work ${SANDBOX} --user stevesmythe"
  [ "$status" -eq 0 ]
  difflist test/difflists/006.txt
}

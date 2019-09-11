#!/usr/bin/env bats

load test_helper

@test "scenario_012_bitbucket" {
  wipe_component_repo_contents
  wipe_other_repo_contents
  teardown
  setup

  run bash -c "${APP} --commit --spec test/specs/bitbucket/009.yml --work ${SANDBOX} --user stevesmythe"
  [ "$status" -eq 0 ]
  difflist test/difflists/009.txt

  run bash -c "${APP} --commit --spec test/specs/bitbucket/012.yml --work ${SANDBOX} --user stevesmythe --force=*"
  [ "$status" -eq 0 ]
  difflist test/difflists/012.txt
}

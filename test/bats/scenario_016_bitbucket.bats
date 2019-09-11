#!/usr/bin/env bats

load test_helper

@test "scenario_016_bitbucket" {
  wipe_component_repo_contents
  wipe_other_repo_contents
  teardown
  setup

  run bash -c "${APP} --commit --spec test/specs/bitbucket/013.yml --work ${SANDBOX} --user stevesmythe"
  [ "$status" -eq 0 ]
  difflist test/difflists/013.txt

  run bash -c "${APP} --commit --spec test/specs/bitbucket/016.yml --work ${SANDBOX} --user stevesmythe --force=*"
  [ "$status" -eq 0 ]
  difflist test/difflists/016.txt
}

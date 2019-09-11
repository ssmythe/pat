#!/usr/bin/env bats

load test_helper

@test "scenario_017_bitbucket" {
  wipe_component_repo_contents
  wipe_other_repo_contents
  teardown
  setup

  run bash -c "${APP} --commit --spec test/specs/bitbucket/017.yml --work ${SANDBOX} --user stevesmythe"
  [ "$status" -eq 0 ]
  difflist test/difflists/017.txt
}

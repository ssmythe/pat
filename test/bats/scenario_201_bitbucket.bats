#!/usr/bin/env bats

load test_helper

@test "scenario_201_bitbucket" {
  wipe_component_repo_contents
  teardown
  setup

  run bash -c "${APP} --commit --spec test/specs/bitbucket/201.yml --work ${SANDBOX} --user stevesmythe"
  [ "$status" -eq 0 ]
  [ ! -f ${COMPONENT}/hello.sh ]
}

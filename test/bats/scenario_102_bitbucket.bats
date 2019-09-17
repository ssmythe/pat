#!/usr/bin/env bats

load test_helper

@test "scenario_102_bitbucket" {
  wipe_component_repo_contents
  teardown
  setup

  run bash -c "${APP} --commit --spec test/specs/bitbucket/101.yml --work ${SANDBOX} --user stevesmythe"
  [ "$status" -eq 0 ]
  difflist test/difflists/101.txt

  run bash -c "${APP} --commit --spec test/specs/bitbucket/102.yml --work ${SANDBOX} --user stevesmythe --force=hello"
  [ "$status" -eq 0 ]
  difflist test/difflists/102.txt
}

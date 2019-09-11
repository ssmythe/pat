#!/usr/bin/env bash

CWD="$(pwd)"
APP="${CWD}/pat"
EXPECTED="${CWD}/test/expected"
SPECS="${CWD}/test/specs"
LOCAL_TEMPLATES="${CWD}/test/local/templates"
SANDBOX="${CWD}/sandbox"
TEMPLATES="${SANDBOX}/templates"
COMPONENT="${SANDBOX}/component"
OTHER="${SANDBOX}/other"

if [ ! -f "${APP}" ]; then
  echo "ERROR: ${APP} doesn't exist!"
  exit 1
fi

function setup() {
  [[ -d "${SANDBOX}" ]] && rm -fr "${SANDBOX}"
  mkdir -p "${SANDBOX}"
}

function seed_hello_world() {
  mkdir -p "${COMPONENT}"
  echo "#!/usr/bin/env bash" >${COMPONENT}/hello.sh
  echo "" >>${COMPONENT}/hello.sh
  echo "echo \"Hello, World!\"" >>${COMPONENT}/hello.sh
}

function seed_local_templates() {
  mkdir -p "${TEMPLATES}"
  rsync -qavz "${LOCAL_TEMPLATES}/" "${TEMPLATES}/."
}

function wipe_component_repo_contents() {
  pushd ${SANDBOX}
  git clone https://stevesmythe@bitbucket.org/smythefamily/pat_test_component.git component
  cd ${COMPONENT}
  git rm \* || true
  git commit -m "wiping repo contents" || true
  git push origin master || true
  popd
}

function wipe_other_repo_contents() {
  pushd ${SANDBOX}
  git clone https://stevesmythe@bitbucket.org/smythefamily/pat_test_other.git other
  cd ${OTHER}
  git rm \* || true
  git commit -m "wiping repo contents" || true
  git push origin master || true
  popd
}

function teardown() {
  rm -fr "${SANDBOX}"
}

function debug() {
  line_num=0
  for line in "${lines[@]}"; do
    echo "debug lines[${line_num}] ${line}"
    line_num=$((line_num + 1))
  done
}

function difflist() {
  list=$1

  while IFS= read -r files; do
    eval diff ${files}
    if [ $? -ne 0 ]; then
      return 1
    fi
  done <${list}
}

#!/bin/bash

echo git pull ...
git pull

RELEASE_BRANCH_NAME="master"
CURRENT_BRANCH_NAME=$(git branch | grep ^* | sed s/^[^[:blank:]][[:blank:]]//)
TAG_LATEST_VERSION=$(git tag | grep -E "[0-9]+\.[0-9]+\.[0-9]+" | sort -V | tail -1)
DIRECTORY=$(cd $(dirname -- "$0") && pwd -P)
PROGRAM="$(dirname -- "${DIRECTORY}")/laws"
VERSION=$("${PROGRAM}" version | sed s/[^[:blank:]]*[[:blank:]]*//)

#{
#  TEST_SCRIPT="${DIRECTORY}/test.sh"
#  printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- ${TEST_SCRIPT} Testing ----------------"
#  if "${TEST_SCRIPT}"; then
#    printf "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- ${TEST_SCRIPT} Passed ----------------"
#  else
#    printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == ${TEST_SCRIPT} Failed ================"; exit 1
#  fi
#}

printf "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- release ${VERSION} ----------------"
if [ "${VERSION}" != "${TAG_LATEST_VERSION}" ]; then
  if [ "${RELEASE_BRANCH_NAME}" != "${CURRENT_BRANCH_NAME}" ]; then
    printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == current branch is ${CURRENT_BRANCH_NAME} ================"
    printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] Please git checkout ${RELEASE_BRANCH_NAME}"
    exit 1
  fi
  if [ "`git diff`" ] || [ "`git diff --staged`" ]; then
    printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == uncommitted changes ================"
    printf "\e[1;31m%s\e[0m\n" "$({ git diff; git diff --staged; } | sed "s/^/`LANG=C date` [ERROR] /")"
    printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] Please git add -A && git commit"
    exit 1
  fi
  git push
  git tag -a ${VERSION} -m "release ${VERSION}"
  git push origin ${VERSION}
  git checkout ${CURRENT_BRANCH_NAME}
  printf "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- release ${VERSION} Passed ----------------"
else
  printf "\e[1;33m%s\e[0m\n" "`LANG=C date` [WARN]  == ${VERSION} already exist ================"
fi

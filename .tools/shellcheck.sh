#!/bin/bash

DIRECTORY="$(cd -- "$(dirname -- "$0")" && pwd -P)"
PROGRAM="$(dirname -- "${DIRECTORY}")/laws"

printf "\e[1;37m%s\e[0m\n" "$(LANG=C date) [TEST]  -- shellcheck ${PROGRAM} Testing ----------------"
if shellcheck "${PROGRAM}"; then
  printf   "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- shellcheck ${PROGRAM} Passed ----------------"
else
  printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == shellcheck ${PROGRAM} Failed ================"; exit 1
fi


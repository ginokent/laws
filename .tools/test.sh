#!/bin/bash

set -x

printf "\n\e[32m%s\e[0m\n" "$(LANG=C date) [TEST]  List buckets"
TEST_01="
$(./lw s3 list | head -10)
"

printf "\n\e[32m%s\e[0m\n" "$(LANG=C date) [TEST]  List objects"
TEST_02="
$(./lw s3 list "s3://$(set +x; echo "${TEST_01}" | grep -Ev '^$|\$' | head -1 | sed 's/[^[:space:]]*[[:space:]]//')" | head -10)
"

printf "\n\e[32m%s\e[0m\n" "$(LANG=C date) [TEST]  Get object"
TEST_03="
$(./lw s3 get "s3://$(set +x; echo "${TEST_01}" | grep -Ev '^$|\$' | head -1 | sed 's/[^[:space:]]*[[:space:]]//')/$(set +x; echo "${TEST_02}" | grep -Ev '^$|\$' | head -1 | sed 's/[^[:space:]]*[[:space:]]//')" | LANG=C sed 's/[^[:graph:][:space:]]*//g' | head -10)
"

printf "\n\e[32m%s\e[0m\n" "$(LANG=C date) [TEST]  List buckets"
TEST_04="
$(./lw s3 list | tail -10)
"

printf "\n\e[32m%s\e[0m\n" "$(LANG=C date) [TEST]  List objects"
TEST_05="
$(./lw s3 list "s3://$(set +x; echo "${TEST_04}" | grep -Ev '^$|\$' | tail -1 | sed 's/[^[:space:]]*[[:space:]]//')" | tail -10)
"

printf "\n\e[32m%s\e[0m\n" "$(LANG=C date) [TEST]  Get object"
TEST_06="
$(./lw s3 get "s3://$(set +x; echo "${TEST_04}" | grep -Ev '^$|\$' | tail -1 | sed 's/[^[:space:]]*[[:space:]]//')/$(set +x; echo "${TEST_05}" | grep -Ev '^$|\$' | tail -1 | sed 's/[^[:space:]]*[[:space:]]//')" | LANG=C sed 's/[^[:graph:][:space:]]*//g' | tail -10)
"


set +x

if   [ -n "$(echo ${TEST_01} | grep -Ev '^$|^<.*>$')" ] \
  && [ -n "$(echo ${TEST_02} | grep -Ev '^$|^<.*>$')" ] \
  && [ -n "$(echo ${TEST_03} | grep -Ev '^$|^<.*>$')" ] \
  && [ -n "$(echo ${TEST_04} | grep -Ev '^$|^<.*>$')" ] \
  && [ -n "$(echo ${TEST_05} | grep -Ev '^$|^<.*>$')" ] \
  && [ -n "$(echo ${TEST_06} | grep -Ev '^$|^<.*>$')" ]; then
  printf "\n\e[32m%s\e[0m\n" "$(LANG=C date) [INFO]  Passed test"
else
  printf "\n\e[31m%s\e[0m\n" "$(LANG=C date) [ERROR] Failed test" && exit 1
fi



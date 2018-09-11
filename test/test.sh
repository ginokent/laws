#!/bin/bash

#set -x

printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- ./test/test.sh Testing... ----------------"

printf "\e[1;37m%s\e[0m\n" "$(LANG=C date) [TEST]  -- List buckets ----------------"
TEST_01="$(
  ./laws s3 list | sed "s/^/$(LANG=C date) [TEST]  /" | tee /dev/stderr | sed 's/.*[TEST][[:blank:]]*//g'
)"

printf "\e[1;37m%s\e[0m\n" "$(LANG=C date) [TEST]  -- List objects (MaxKeys=${MaxKeys:=100}) ----------------"
TEST_02="$(
  ./laws s3 list "s3://$(
    set +x; echo "${TEST_01}" | grep -Ev '^$|\$' | head -1 | sed 's/[^[:blank:]]*[[:blank:]]*//'
  )" | sed "s/^/$(LANG=C date) [TEST]  /" | tee /dev/stderr | sed 's/.*[TEST][[:blank:]]*//g'
)"

printf "\e[1;37m%s\e[0m\n" "$(LANG=C date) [TEST]  -- Get object ----------------"
TEST_03="$(
  ./laws s3 get "s3://$(
    set +x; echo "${TEST_02}" | grep -Ev '^$|\$' | head -1 | sed 's/[^[:space:]]*[[:space:]]//'
  )" | LANG=C sed 's/[^[:graph:][:space:]]*//g' | sed "s/^/$(LANG=C date) [TEST]  /" | { cat; echo; } | tee /dev/stderr | sed 's/.*[TEST][[:blank:]]*//g'
)"

printf "\e[1;37m%s\e[0m\n" "$(LANG=C date) [TEST]  -- List buckets ----------------"
TEST_04="$(
  ./laws s3 list | sed "s/^/$(LANG=C date) [TEST]  /" | tee /dev/stderr | sed 's/.*[TEST][[:blank:]]*//g'
)"

printf "\e[1;37m%s\e[0m\n" "$(LANG=C date) [TEST]  -- List objects (MaxKeys=${MaxKeys:=1000}) ----------------"
TEST_05="$(
  ./laws s3 list "s3://$(
    set +x; echo "${TEST_04}" | grep -Ev '^$|\$' | tail -1 | sed 's/[^[:space:]]*[[:space:]]//'
  )" | sed "s/^/$(LANG=C date) [TEST]  /" | tee /dev/stderr | sed 's/.*[TEST][[:blank:]]*//g'
)"

printf "\e[1;37m%s\e[0m\n" "$(LANG=C date) [TEST]  -- Get object ----------------"
TEST_06="$(
  ./laws s3 get "s3://$(
    set +x; echo "${TEST_05}" | grep -Ev '^$|\$' | tail -1 | sed 's/[^[:space:]]*[[:space:]]//'
  )" | LANG=C sed 's/[^[:graph:][:space:]]*//g' | sed "s/^/$(LANG=C date) [TEST]  /" | { cat; echo; } | tee /dev/stderr | sed 's/.*[TEST][[:blank:]]*//g'
)"


set +x; if   [ -n "$(echo ${TEST_01} | grep -Ev '^$|^<.*>$')" ] \
  && [ -n "$(echo ${TEST_02} | grep -Ev '^$|^<.*>$')" ] \
  && [ -n "$(echo ${TEST_03} | grep -Ev '^$|^<.*>$')" ] \
  && [ -n "$(echo ${TEST_04} | grep -Ev '^$|^<.*>$')" ] \
  && [ -n "$(echo ${TEST_05} | grep -Ev '^$|^<.*>$')" ] \
  && [ -n "$(echo ${TEST_06} | grep -Ev '^$|^<.*>$')" ]; then
  printf "\e[32m%s\e[0m\n" "$(LANG=C date) [INFO]  -- $0 Passed ----------------"
else
  printf "\e[1;31m%s\e[0m\n" "$(LANG=C date) [ERROR] == $0 Failed ================" && exit 1
fi



#!/usr/bin/env bash
# shellcheck disable=SC2059

[ "${MaxKeys}" ] || MaxKeys=50
DIRECTORY="$(cd -- "$(dirname -- "$0")" && pwd -P)"
PROGRAM="$(dirname -- "${DIRECTORY}")/laws"

Date() { LC_ALL=C date; }

format_default="\e[1;37m%s\e[0m\n"
format_info="\e[1;32m%s\e[0m\n"
format_error="\e[1;31m%s\e[0m\n"

printf "${format_default}" "$(Date) [TEST]  -- Help Testing ----------------"
HELP_S3=$("${PROGRAM}" help 2>&1 | head -7 | tee /dev/stderr | grep "Lightweight shell script for Amazon Web Service Command Line Interface like AWS CLI.")
if [ "${HELP_S3}" ]; then
  printf "${format_info}" "$(Date) [INFO]  -- Help Passed ----------------"
else
  printf "${format_error}" "$(Date) [ERROR] == Help Failed ================"; exit 1
fi

printf "${format_default}" "$(Date) [TEST]  -- List buckets Testing ----------------"
if "${PROGRAM}" s3 ls; then
  printf "${format_info}" "$(Date) [INFO]  -- List buckets Passed ----------------"
else
  printf "${format_error}" "$(Date) [ERROR] == List buckets Failed ================"; exit 1
fi

printf "${format_default}" "$(Date) [TEST]  -- List objects (MaxKeys=${MaxKeys}) Testing ----------------"
if "${PROGRAM}" s3 ls-recursive "$("${PROGRAM}" s3 ls-recursive | grep -Ev '^$|\$' | head -1 | sed 's/[^[:blank:]]*[[:blank:]]*//')"; then
  printf "${format_info}" "$(Date) [INFO]  -- List objects (MaxKeys=${MaxKeys}) Passed ----------------"
else
  printf "${format_error}" "$(Date) [ERROR] == List objects (MaxKeys=${MaxKeys}) Failed ================"; exit 1
fi

printf "${format_default}" "$(Date) [TEST]  -- Get object Testing ----------------"
if "${PROGRAM}" s3 cat "$(MaxKeys=1000 "${PROGRAM}" s3 ls-recursive "$("${PROGRAM}" s3 ls-recursive | grep -Ev '^$|\$' | head -1 | sed 's/[^[:blank:]]*[[:blank:]]*//')" | grep -Ev '^$|\$' | head -1 | sed 's/[^[:blank:]]*[[:blank:]]*//')" | LC_ALL=C sed 's/[^[:graph:][:blank:]]*//g'; then
  printf "${format_info}" "$(Date) [INFO]  -- Get objects Passed ----------------"
else
  printf "${format_error}" "$(Date) [ERROR] == Get objects Failed ================"; exit 1
fi

printf "${format_default}" "$(Date) [TEST]  -- List objects (MaxKeys=${MaxKeys}) Testing ----------------"
if ("${PROGRAM}" s3 ls-recursive "$("${PROGRAM}" s3 ls-recursive | grep -Ev '^$|\$' | tail -1 | sed s/[^[:blank:]]*[[:blank:]]*//)"); then
  printf "${format_info}" "$(Date) [INFO]  -- List objects (MaxKeys=${MaxKeys}) Passed ----------------"
else
  printf "${format_error}" "$(Date) [ERROR] == List objects (MaxKeys=${MaxKeys}) Failed ================"; exit 1
fi

printf "${format_default}" "$(Date) [TEST]  -- Get object Testing ----------------"
if ("${PROGRAM}" s3 cat "$(MaxKeys=1000 "${PROGRAM}" s3 ls-recursive "$("${PROGRAM}" s3 ls-recursive | grep -Ev '^$|\$' | tail -1 | sed s/[^[:blank:]]*[[:blank:]]*//)" | grep -Ev '^$|\$' | tail -1 | sed s/[^[:blank:]]*[[:blank:]]*//)" | LC_ALL=C sed s/[^[:graph:][:blank:]]*//g); then
  printf "\n\e[1;32m%s\e[0m\n" "$(Date) [INFO]  -- Get objects Passed ----------------"
else
  printf "${format_error}" "$(Date) [ERROR] == Get objects Failed ================"; exit 1
fi

##
# PUT
##
printf "${format_default}" "$(Date) [TEST]  -- Copy (PUT/GET) object Testing ----------------"
put=$(date +%s | tee ./b)
# local to s3
"${PROGRAM}" s3 cp ./b "$("${PROGRAM}" s3 ls-recursive | grep -Ev '^$|\$' | tail -1 | sed 's/[^[:blank:]]*[[:blank:]]*//')tmp/date" >/dev/stderr
# s3 to local
"${PROGRAM}" s3 cp "$("${PROGRAM}" s3 ls-recursive | grep -Ev '^$|\$' | tail -1 | sed 's/[^[:blank:]]*[[:blank:]]*//')tmp/date" ./a >/dev/stderr
get=$(cat ./a)
current=$(date +%s)
echo "put content  : ${put}"
echo "get content  : ${get}"
echo "current time : ${current}"
echo "delta time   : $((current-put))"
if [ "${put:="0"}" = "${get:="1"}" ] && [ $((current-put)) -le 20 ]; then
  printf "\n\e[1;32m%s\e[0m\n" "$(Date) [INFO]  -- Copy (PUT/GET) objects Passed ----------------"
  test ! -f ./a || rm "$_"
  test ! -f ./b || rm "$_"
else
  printf "${format_error}" "$(Date) [ERROR] == Copy (PUT/GET) objects Failed ================"; exit 1
  test ! -f ./a || rm "$_"
  test ! -f ./b || rm "$_"
fi


#!/bin/bash

[ "${MaxKeys}" ] || MaxKeys=50
DIRECTORY="$(cd -- "$(dirname -- "$0")" && pwd -P)"
PROGRAM="$(dirname -- "${DIRECTORY}")/laws"

printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- List buckets Testing ----------------"
if ("${PROGRAM}" s3 ls); then
  printf "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- List buckets Passed ----------------"
else
  printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == List buckets Failed ================"; exit 1
fi

printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- List objects (MaxKeys=${MaxKeys}) Testing ----------------"
if ("${PROGRAM}" s3 ls "s3://$("${PROGRAM}" s3 ls | grep -Ev '^$|\$' | head -1 | sed s/[^[:blank:]]*[[:blank:]]*//)"); then
  printf "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- List objects (MaxKeys=${MaxKeys}) Passed ----------------"
else
  printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == List objects (MaxKeys=${MaxKeys}) Failed ================"; exit 1
fi

printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- Get object Testing ----------------"
if ("${PROGRAM}" s3 cat "s3://$(MaxKeys=1000 "${PROGRAM}" s3 ls "s3://$("${PROGRAM}" s3 ls | grep -Ev '^$|\$' | head -1 | sed s/[^[:blank:]]*[[:blank:]]*//)" | grep -Ev '^$|\$' | head -1 | sed s/[^[:blank:]]*[[:blank:]]*//)" | LANG=C sed s/[^[:graph:][:blank:]]*//g); then
  echo; printf "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- Get objects Passed ----------------"
else
  echo; printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == Get objects Failed ================"; exit 1
fi

printf "\e[1;37m%s\e[0m\n" "$(LANG=C date) [TEST]  -- List objects (MaxKeys=${MaxKeys}) Testing ----------------"
if ("${PROGRAM}" s3 ls "s3://$("${PROGRAM}" s3 ls | grep -Ev '^$|\$' | tail -1 | sed s/[^[:blank:]]*[[:blank:]]*//)"); then
  printf "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- List objects (MaxKeys=${MaxKeys}) Passed ----------------"
else
  printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == List objects (MaxKeys=${MaxKeys}) Failed ================"; exit 1
fi

printf "\e[1;37m%s\e[0m\n" "$(LANG=C date) [TEST]  -- Get object Testing ----------------"
if ("${PROGRAM}" s3 cat "s3://$(MaxKeys=1000 "${PROGRAM}" s3 ls "s3://$("${PROGRAM}" s3 ls | grep -Ev '^$|\$' | tail -1 | sed s/[^[:blank:]]*[[:blank:]]*//)" | grep -Ev '^$|\$' | tail -1 | sed s/[^[:blank:]]*[[:blank:]]*//)" | LANG=C sed s/[^[:graph:][:blank:]]*//g); then
  echo; printf "\n\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- Get objects Passed ----------------"
else
  echo; printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == Get objects Failed ================"; exit 1
fi

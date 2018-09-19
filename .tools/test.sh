#!/bin/bash

[ "${MaxKeys}" ] || MaxKeys=50
DIRECTORY="$(cd -- "$(dirname -- "$0")" && pwd -P)"
PROGRAM="$(dirname -- "${DIRECTORY}")/laws"

printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- Help Testing ----------------"
HELP_S3_LS=$("${PROGRAM}" s3 ls test -h 2>&1 | head -7 | tee /dev/stderr | grep "Lightweight shell script for Amazon Web Service Command Line Interface like AWS CLI.")
HELP_S3_CAT=$("${PROGRAM}" s3 cat -h 2>&1 | head -7 | tee /dev/stderr | grep "Lightweight shell script for Amazon Web Service Command Line Interface like AWS CLI.")
HELP_S3_CP=$("${PROGRAM}" s3 cp -h 2>&1 | head -7 | tee /dev/stderr | grep "Lightweight shell script for Amazon Web Service Command Line Interface like AWS CLI.")
if [ "${HELP_S3_LS}" ] && [ "${HELP_S3_CAT}" ] && [ "${HELP_S3_CP}" ]; then
  printf "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- Help Passed ----------------"
else
  printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == Help Failed ================"; exit 1
fi

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

#
# PUT
#
printf "\e[1;37m%s\e[0m\n" "$(LANG=C date) [TEST]  -- Copy (PUT/GET) object Testing ----------------"
put=$(date +%s | tee ./b)
# local to s3
"${PROGRAM}" s3 cp ./b "s3://$("${PROGRAM}" s3 ls | grep -Ev '^$|\$' | tail -1 | sed s/[^[:blank:]]*[[:blank:]]*//)/tmp/date" >/dev/stderr
# s3 to local
"${PROGRAM}" s3 cp "s3://$("${PROGRAM}" s3 ls | grep -Ev '^$|\$' | tail -1 | sed s/[^[:blank:]]*[[:blank:]]*//)/tmp/date" ./a >/dev/stderr
get=$(cat ./a)
current=$(date +%s)
echo "put content  : ${put}"
echo "get content  : ${get}"
echo "current time : ${current}"
echo "delta time   : $((current-put))"
if [ ${put:="0"} = ${get:="1"} ] && [ $((current-put)) -le 20 ]; then
  echo; printf "\n\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- Copy (PUT/GET) objects Passed ----------------"
  rm ./b ./a
else
  echo; printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == Copy (PUT/GET) objects Failed ================"; exit 1
fi



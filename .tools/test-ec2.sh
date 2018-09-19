#!/bin/bash

set -e

# log
printf "\e[1;37m%s\e[0m\n" "$(LANG=C date) [INFO]  -- Remote Test ----------------"

# local vars
echo "LAWS_LOCAL_REPOSITORY  : ${LAWS_LOCAL_REPOSITORY:="${HOME}/djeeno/laws/"}"
echo "LAWS_REMOTE_HOST       : ${LAWS_REMOTE_HOST:="52.193.197.82"}"
echo "LAWS_REMOTE_USER       : ${LAWS_REMOTE_USER:="ubuntu"}"
echo "LAWS_REMOTE_REPOSITORY : ${LAWS_REMOTE_REPOSITORY:="/home/${LAWS_REMOTE_USER}/laws/"}"
echo "LAWS_REMOTE_COMMAND    : ${LAWS_REMOTE_COMMAND:="cd ${LAWS_REMOTE_REPOSITORY} && make test"}"

# enable print commands
set -x

# upload
rsync -e 'ssh -i ~/.ssh/laws.pem' -az ${LAWS_LOCAL_REPOSITORY} ${LAWS_REMOTE_USER}@${LAWS_REMOTE_HOST}:${LAWS_REMOTE_REPOSITORY}

# run test
ssh ${LAWS_REMOTE_USER}@${LAWS_REMOTE_HOST} ${LAWS_REMOTE_COMMAND}

# disable print commands
set +x

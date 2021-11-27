#!/bin/bash

if [[ "${UID}" -ne 0 ]]; then
    echo "Script can only be executed with root privileges" >&2 # Send to standard error
    exit 1
fi

if [[ "${#}" -eq 0 ]]; then
    echo "Please provide user name as command line argument with script, eg: ./better-add-local-user.sh name1 name 2" >&2 # Send to standard error
    exit 1
fi

USER_NAME="${1}"

shift

COMMENT="${@}"

PASSWORD=$(date +%S%N | sha256sum | head -c14)

useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null # Supress all output

if [[ "${?}" -ne 0 ]]; then
    echo "Error in creating the account" >&2 # Send to standard error
    exit 1
fi

echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null # Supress all output

passwd -e ${USER_NAME} &>  /dev/null # Supress all output

echo "username: ${USER_NAME}"
echo "password: ${PASSWORD}"
echo "host: ${HOSTNAME}"

exit 0
#!/bin/bash

if [[ "${UID}" -ne 0 ]]; then
    echo "Script can only be executed with root privileges"
    exit 1
fi

if [[ "${#}" -eq 0 ]]; then
    echo "Please provide user name as command line argument with script, eg: ./better-add-local-user.sh name1 name 2"
    exit 1
fi

USER_NAME="${1}"

shift

COMMENT="${@}"

useradd -c "${COMMENT}" -m ${USER_NAME}

if [[ "${?}" -ne 0 ]]; then
    echo "Error in creating the account"
    exit 1
fi

PASSWORD=$(date +%S%N | sha256sum | head -c14)

echo ${PASSWORD} | passwd --stdin ${USER_NAME}

passwd -e ${USER_NAME}

echo "username: ${USER_NAME}"
echo "password: ${PASSWORD}"
echo "host: ${HOSTNAME}"

exit 0

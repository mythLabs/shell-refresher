#!/bin/bash

if [[ "${UID}" -ne 0 ]]; then
  echo "Script can only be executed with root privileges"
  exit 1
fi

# create user on local system
read -p 'Enter username to create:' USER_NAME

# Ask for real name
read -p 'Enter name of the person:' COMMENT

#Ask for password
read -p 'Enter password:' PASSWORD

useradd -c "${COMMENT}" -m ${USER_NAME}

if [[ "${?}" -ne 0 ]]; then
  echo "Error in creating the account"
  exit 1
fi

echo ${PASSWORD} | passwd --stdin ${USER_NAME}

passwd -e ${USER_NAME}

echo "username: ${USER_NAME}"
echo "password: ${PASSWORD}"
echo "host: ${HOSTNAME}"

exit 0

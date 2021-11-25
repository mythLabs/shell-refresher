#!/bin/bash

# create user on local system
read -p 'Enter username to create:' USER_NAME

# Ask for real name
read -p 'Enter name of the person:' COMMENT

#Ask for password
read -p 'Enter password:' PASSWORD

useradd -c "${COMMENT}" -m ${USER_NAME}

echo ${PASSWORD} | passwd --stdin ${USER_NAME}

passwd -e ${USER_NAME}
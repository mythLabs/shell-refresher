#!/bin/bash

echo "Hello"

WORD='script'

echo "$WORD"

# Interpolation
echo "${WORD}s"


# Display data of user executing script

echo "Your UID is ${UID}"

USER_NAME=$(id -un)

# Test if the command succesed - ${?} = exit status of most recent command
if [[ "${?}" -ne 0 ]]
then
   echo 'The id command did not execute successfully'
   exit 1
fi

echo "username is ${USER_NAME}"

if [[ "${UID}" -eq 0 ]]
then
   echo 'root'
else 
   echo 'not root'
fi

UID_TO_TEST_FOR='1000'

if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
   echo "Your UID does not match ${UID_TO_TEST_FOR}"
   exit 1
fi

USER_NAME_TO_TEST_FOR="amit"

if [[ "${USER_NAME_TO_TEST_FOR}" = "${USER_NAME_TO_TEST_FOR}" ]] # == means pattern match
then 
   echo "Username matched ${USER_NAME_TO_TEST_FOR}"
   exit 1
fi

exit 0
#!/bin/bash

readonly ARCHIVE_DIR='/archive'

usage() {
    echo "Usage: ${0} [-dra] USER [USERN]..."
    exit 1
}

if [[ "${UID}" -ne 0 ]]; then
    echo "Script can only be executed with root privileges"
    exit 1
fi

while getopts dra OPTION; do
    case ${OPTION} in
    d) DELETE_USER='true' ;;
    r) REMOVE_OPTION='-r' ;;
    a) ARCHIVE='true' ;;
    *) usage ;;
    esac
done

shift "$((OPTIND - 1))"

if [[ "${#}" -eq 0 ]]; then
    usage
fi

for USERNAME in "${@}"; do
    echo "processing ${USERNAME}"

    UID=$(id -u USERNAME)
    if [[ "${UID}" -lt 1000 ]]; then
        echo "Cannot remove system account"
        exit 1
    fi

    if [[ "${ARCHIVE}" = 'true' ]]; then

        # Make sure  ARCHIVE directory exists
        if [[ ! -d "${ARCHIVE_DIR}" ]]; then
            echo "Creating directory ${ARCHIVE_DIR}"
            mkdir -p "${ARCHIVE_DIR}"
            if [[ "${?}" -ne 0 ]]; then
                echo "Unable to create ${ARCHIVE_DIR}"
                exit 1
            fi
        fi

        HOME_DIR="/home/${USERNAME}"
        ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"

        if [[ -d "${HOME_DIR}" ]]; then
            echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
            tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &>/dev/null
            if [[ "${?}" -ne 0 ]]; then
                echo "Unable to tar backup"
                exit 1
            fi
        else
            echo "${HOME_DIR} does not exist or is not a directory"
            exit 1
        fi

    fi

    if [[ "${DELETE_USER}" = 'true' ]]; then
        userdel ${REMOVE_OPTION} ${USERNAME}
        if [[ "${?}" -ne 0 ]]; then
            echo "Unable to delete user: ${USERNAME}"
            exit 1
        fi

        echo "${USERNAME} deleted"

    else
        chage -E 0 ${USERNAME}

        if [[ "${?}" -ne 0 ]]; then
            echo "Unable to disable user: ${USERNAME}"
            exit 1
        fi
        echo "${USERNAME} was disabled"
    fi
done

exit 0

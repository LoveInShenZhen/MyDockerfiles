#!/bin/sh

# generate host keys if not present
ssh-keygen -A

# check wether a random root-password is provided
if [ ! -z "${ROOT_PASSWORD}" ] && [ "${ROOT_PASSWORD}" != "root" ]; then
    echo "root:${ROOT_PASSWORD}" | chpasswd
fi

export PATH=/opt/jdk/bin:$PATH

# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D -e "$@"

#!/bin/sh

echo "custom init env"

ln -s /lib/libc.so /usr/lib/libc.so

# auto resize rootfs
ROOTFS=$(cat /proc/cmdline | grep -Eo "root=[^ ]*" | awk -F '=' '{print $2}')
resize2fs $ROOTFS

exit 0

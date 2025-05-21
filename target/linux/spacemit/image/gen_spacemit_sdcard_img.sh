#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024 Spacemit Ltd.


echo "gen sdcard image print"
#set -ex
set -e
[ $# -eq 5 ] || {
    echo "SYNTAX: $0 <file> <boot image> <rootfs image> <bootfs size> <rootfs size>"
    exit 1
}

OUTPUT="$1"
IMGS_DIR=$(dirname $1)

#Bootinfo contains only the first 80 bytes of valid data.
BOOTINFO=${IMGS_DIR}/factory/bootinfo_sd.bin

FSBL=${IMGS_DIR}/factory/FSBL.bin
FSBL_SIZE=256
FSBL_OFFSET=128

#if flash env.bin is optional, but env part must be fixed offset at 512k
UENV=${IMGS_DIR}/env.bin
UENV_SIZE=64
UENV_OFFSET=384

OPENSBI=${IMGS_DIR}/fw_dynamic.itb
OPENSBI_SIZE=384

UBOOT=${IMGS_DIR}/u-boot.itb
UBOOT_SIZE=2

BOOTFS="$2"
BOOTFS_SIZE=$4

ROOTFS="$3"

ROOTFS_SIZE=$5
head=4
sect=63

#unit is kbytes default
set $(ptgen -o $OUTPUT -v -g -h $head -s $sect \
    -N fsbl -p $FSBL_SIZE@$FSBL_OFFSET \
    -N env -p $UENV_SIZE@$UENV_OFFSET \
    -N opensbi -p $OPENSBI_SIZE \
    -N uboot -p ${UBOOT_SIZE}M \
    -N bootfs -p ${BOOTFS_SIZE}M \
    -N rootfs -p ${ROOTFS_SIZE}M)

OPENSBI_OFFSET=$(($5 / 1024))
UBOOT_OFFSET=$(($7 / 1024))
BOOTFS_OFFSET=$(($9 / 1024))
ROOTFS_OFFSET=$((${11} / 1024))

#Bootinfo contains only the first 80 bytes of valid data.
dd bs=80   if="$BOOTINFO" of="$OUTPUT" seek=0 count=1         conv=notrunc
dd bs=1024 if="$FSBL"     of="$OUTPUT" seek=${FSBL_OFFSET}    conv=notrunc
dd bs=1024 if="$UENV"     of="$OUTPUT" seek=${UENV_OFFSET}    conv=notrunc
dd bs=1024 if="$OPENSBI"  of="$OUTPUT" seek=${OPENSBI_OFFSET} conv=notrunc
dd bs=1024 if="$UBOOT"    of="$OUTPUT" seek=${UBOOT_OFFSET}   conv=notrunc
dd bs=1024 if="$BOOTFS"   of="$OUTPUT" seek=${BOOTFS_OFFSET}  conv=notrunc
dd bs=1024 if="$ROOTFS"   of="$OUTPUT" seek=${ROOTFS_OFFSET}  conv=notrunc

echo "$OUTPUT successfully generated"

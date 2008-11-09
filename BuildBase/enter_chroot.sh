#!/bin/sh -v

cd $(dirname $(which $0))
. create_env.inc

DEVPLACE="${ROOTDIR}/System/Kernel/Devices"
mount | grep -q "${DEVPLACE}" || mount -t devfs dev "${DEVPLACE}"
mount | grep -q "${DEVPLACE}/fd" || mount -t fdescfs fdesc "${DEVPLACE}/fd"

# Compile/FiboSandbox needs nullfs
kldstat | grep -q nullfs || kldload nullfs

if [ -d ${BOOTDIR} ]; then
mount | grep "${BOOTDIR}" | grep -q "${ROOTDIR}/System/Kernel/Boot" || mount -t nullfs ${BOOTDIR}/boot ${ROOTDIR}/System/Kernel/Boot
fi

env -i TERM=$TERM /usr/sbin/chroot ${ROOTDIR} su -l

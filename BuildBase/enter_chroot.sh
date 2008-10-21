#!/bin/sh -v

cd $(dirname $(which $0))
. create_env.inc

DEVPLACE="${ROOTDIR}/System/Kernel/Devices"
mount | grep -q "${DEVPLACE}" || mount -t devfs dev "${DEVPLACE}"

env -i TERM=$TERM /usr/sbin/chroot ${ROOTDIR} su -l

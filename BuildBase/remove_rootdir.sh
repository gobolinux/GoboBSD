#!/bin/sh -v

cd $(dirname $(which $0))
. create_env.inc

DEVPLACE="${ROOTDIR}/System/Kernel/Devices"
umount ${DEVPLACE}

chflags -R noschg ${ROOTDIR}
rm -rf ${ROOTDIR}

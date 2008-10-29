#!/bin/sh

cd $(dirname $(which $0))
. create_env.inc

makefs ${BOOTDIR}/boot/root.fs ${ROOTDIR}
gzip -9 ${BOOTDIR}/boot/root.fs

cat > ${BOOTDIR}/boot/loader.conf << "EOF"
mfsroot_load="YES"
mfsroot_type="mfs_root"
mfsroot_name="/boot/root.fs"
vfs.root.mountfrom="ufs:md0"
kernel="GENERIC"
EOF

mkisofs -b boot/cdboot -no-emul-boot -r -J -V "GoboBSD" -publisher "littlefox" -o $1.iso ${BOOTDIR}

#!/bin/sh -v

. create_env.inc

if [ ! -d ${BOOTDIR} ]; then
  mkdir ${BOOTDIR}
  tar cf - -C ${DESTDIR} boot | tar -xpf - -C ${BOOTDIR}
fi

makefs ${BOOTDIR}/boot/root.fs ${ROOTDIR}
gzip -9 ${BOOTDIR}/boot/root.fs

cat > ${BOOTDIR}/boot/loader.conf << "EOF"
mfsroot_load="YES"
mfsroot_type="mfs_root"
mfsroot_name="/boot/root.fs"
vfs.root.mountfrom="ufs:md0"
kernel="GENERIC"
EOF

#!/bin/sh -v

cd $(dirname $(which $0))
. create_env.inc

if [ ! -d ${BOOTDIR} ]; then
  mkdir ${BOOTDIR}
  tar cf - -C ${DESTDIR} boot | tar -xpf - -C ${BOOTDIR}
fi

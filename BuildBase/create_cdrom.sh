#!/bin/sh
. create_env.inc

mkisofs -b boot/cdboot -no-emul-boot -r -J -V "GoboBSD" -publisher "littlefox" -o $1.iso ${BOOTDIR}

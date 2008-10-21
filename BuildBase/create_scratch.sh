#!/bin/sh
. create_env.inc

mkdir $DESTDIR
cd /cdrom/$RELEASE/base
./install.sh

cd /cdrom/$RELEASE/kernels
./install.sh GENERIC

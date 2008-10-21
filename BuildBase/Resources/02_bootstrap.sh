#!/bin/sh

umask 022

SCRIPTDIR=$(pwd)
if [ ! -f "${SCRIPTDIR}/02_bootstrap.sh" ]; then
  echo Please execute $0 from its directory
  exit
fi

ROOT=
PROGBASE=${ROOT}/Programs/Bootstrap
PROGVER=1.0
PROGDEST=${PROGBASE}/${PROGVER}

if [ ! -d ${PROGDEST} ]; then
  mkdir -p ${PROGDEST}
fi

if [ ! -d ${PROGDEST}/bin ]; then
  mkdir ${PROGDEST}/bin
fi

if [ ! -d ${PROGDEST}/lib ]; then
  mkdir ${PROGDEST}/lib
fi

chown -R fibo ${PROGBASE}
chown -R fibo ${SCRIPTDIR}

su fibo ./03_bootstrap_build.sh

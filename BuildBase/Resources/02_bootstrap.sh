#!/bin/sh

umask 022

export bootstrapScriptsDir=$(pwd)
if [ ! -f "${bootstrapScriptsDir}/02_bootstrap.sh" ]; then
  echo "Please execute $0 from its directory"
  exit 201
fi

# In case DESTDIR for some reason lives on, BSD make would
# start installing stuff in the wrong places
if [ "x${DESTDIR}" != "x" ]; then
  echo DESTDIR variable should not be set! Unsetting it!
  unset DESTDIR
fi

. ./bootstrap_env.inc

if [ ! -d ${bootstrapDest} ]; then
  mkdir -p ${bootstrapDest}
fi

if [ ! -d ${bootstrapDest}/bin ]; then
  mkdir ${bootstrapDest}/bin
fi

if [ ! -d ${bootstrapDest}/lib ]; then
  mkdir ${bootstrapDest}/lib
fi

chown -R fibo ${bootstrapBase}
chown -R fibo ${bootstrapScriptsDir}
chown -R fibo ${sourcesDir}

su fibo ./bootstrap_build.sh || exit 200

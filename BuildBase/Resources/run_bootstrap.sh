#!/bin/sh

if [ ! -d /Programs ]; then
	echo "This doesn't look like a GoboBSD system"
	exit 201
fi

bootstrapScriptsDir=$(pwd)
if [ ! -f "${bootstrapScriptsDir}/run_bootstrap.sh" ]; then
  echo Please execute $0 from its directory
  exit 201
fi

if [ ! -e ./done_01 ]; then
	for f in ./01*.sh; do
		/System/Links/Executables/sh $f || exit 200
	done
	touch ./done_01
fi

if [ ! -e ./done_02 ]; then
	for f in ./02*.sh; do
		/System/Links/Executables/sh $f || exit 200
	done
	touch ./done_02
fi

#!/bin/sh

if [ ! -d /Programs ]; then
	echo "This doesn't look like a GoboBSD system"
	exit 201
fi

bootstrapScriptsDir=$(pwd)
if [ ! -f "${bootstrapScriptsDir}/run_bootstrap.sh" ]; then
  echo "Please execute $0 from its directory"
  exit 201
fi

runscripts()
{
	local level=$1;
	if [ ! -e ./done_${level} ]; then
		for f in ./${level}*.sh; do
			/System/Links/Executables/sh $f || exit 200
		done
		/System/Links/Executables/touch ./done_${level}
	fi
}

runscripts "01"
runscripts "02"
runscripts "03"

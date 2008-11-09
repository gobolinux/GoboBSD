#!/bin/sh

umask 022

export bootstrapScriptsDir=$(pwd)
if [ ! -f "${bootstrapScriptsDir}/03_bootstrap_finalize.sh" ]; then
	echo "Please execute $0 from its directory"
	exit 201
fi

. ./bootstrap_env.inc

# export PYTHONPATH="${ROOT}/System/Links/Libraries/python2.3/site-packages:${ROOT}/System/Links/Libraries/python2.4/site-packages:${ROOT}/System/Links/Libraries/python2.5/site-packages${PYTHONPATH:+:$PYTHONPATH}"
echo ----------------------------------------
echo PATH is $PATH
echo ----------------------------------------
sleep 3

# Fix some stuff that can only be done by superuser
chown 0:0 ${bootstrapDest}/bin/sudo
chmod 4111 ${bootstrapDest}/bin/sudo
chown 0:0 ${bootstrapDest}/etc/sudoers
chmod 0440 ${bootstrapDest}/etc/sudoers
chown -R 0:0 ${ROOT}/Files/Compile

getlastarg()
{
	shift $(($# - 1))
	echo $1
}

findarchive()
{
	set -f
	local myarchive="${1}*"
	set +f

	myarchiveExp=$(cd ${archivesDir}; echo ${myarchive})
	if [ "x${myarchiveExp}" = "x${myarchive}" ]; then
		return 1
	fi
	myarchive=$(getlastarg ${myarchiveExp})
	echo ${myarchive}
	return 0
}

# Scripts will provide install for us
scriptarchive=$(findarchive "Scripts--")
if [ "x${scriptarchive}" = "x" ]; then
	echo "No Scripts archive to unpack"
	exit 200
fi

tar -xf ${archivesDir}/${scriptarchive} -C ${ROOT}/Programs

if [ ! -d ${ROOT}/Programs/Scripts ]; then
	exit 200
fi

cd ${ROOT}/Programs/Scripts/*
SCRIPTPROGDIR=$(pwd)
SCRIPTPROGVER=$(basename $SCRIPTPROGDIR)

set -f
SCRIPTPATCHES="Scripts-${SCRIPTPROGVER}*.patch"
set +f
SCRIPTPATCHESEXP=$(cd ${bootstrapScriptsDir}/; echo ${SCRIPTPATCHES})
if [ "x${SCRIPTPATCHESEXP}" = "x${SCRIPTPATCHES}" ]; then
	SCRIPTPATCHESEXP=""
fi
SCRIPTPATCHES=${SCRIPTPATCHESEXP}
unset SCRIPTPATCHESEXP

for f in ${SCRIPTPATCHES}; do
	patch -Np2 < ${bootstrapScriptsDir}/$f
done

cat >> ${SCRIPTPROGDIR}/Resources/Defaults/Settings/Scripts/Dependencies.blacklist << "EOF"
Glibc
Linux-PAM
EOF

ln -s $(basename ${SCRIPTPROGDIR}) ${SCRIPTPROGDIR}/../Current
cp -R ${SCRIPTPROGDIR}/Resources/Defaults/Settings ${SCRIPTPROGDIR}/../Settings

if [ -x ${SCRIPTPROGDIR}/bin/install ]; then
	if [ -L /System/Links/Executables/install ]; then
		rm ${ROOT}/System/Links/Executables/install
	fi
fi
for f in ${SCRIPTPROGDIR}/bin/*; do
	ln -s ${SCRIPTPROGDIR}/bin/$(basename $f) ${ROOT}/System/Links/Executables
done

# Scripts needs to see some executables, so let's
# symlink them (this is ugly, as other stuff such
# as libs are not symlinked yet)
for f in ${bootstrapDest}/bin/*; do
	ln -s ${bootstrapDest}/bin/$(basename $f) ${ROOT}/System/Links/Executables
done

for f in ${ROOT}/Programs/Scripts/Settings/*; do
	ln -s ${ROOT}/Programs/Scripts/Settings/$(basename $f) ${ROOT}/System/Settings
done


ln -s ${ROOT}/Programs/Scripts/Current/Resources/Environment /System/Links/Environment/Scripts--${SCRIPTPROGVER}


scriptok="no"
MAKE=${bootstrapDest}/bin/gmake
${MAKE} cleanup && ${MAKE} && scriptok="yes"

if [ "x${scriptok}" = "xyes" ]; then
  UpdateSettings Scripts &&
  SymlinkProgram Scripts &&
  SymlinkProgram --force Bootstrap 
else
  echo Something went wrong when building Scripts...
  exit 200
fi

# Post-install work
echo "import site" > ${bootstrapDest}/lib/python2.6/sitecustomize.py
echo 'site.addsitedir("/System/Links/Libraries/python2.6/site-packages/")' >> ${bootstrapDest}/lib/python2.6/sitecustomize.py
echo 'site.addsitedir("/System/Links/Libraries/python2.5/site-packages/")' >> ${bootstrapDest}/lib/python2.6/sitecustomize.py
echo 'site.addsitedir("/System/Links/Libraries/python2.4/site-packages/")' >> ${bootstrapDest}/lib/python2.6/sitecustomize.py
echo 'site.addsitedir("/System/Links/Libraries/python2.3/site-packages/")' >> ${bootstrapDest}/lib/python2.6/sitecustomize.py

# Change shell to bash for FiboSandbox user
pw usermod fibo -s bash

compilepkg=$(findarchive "Compile--")
if [ "x${compilepkg}" = "x" ]; then
	echo "No Compile archive found"
	exit 200
fi

InstallPackage -b -C -D -W "${archivesDir}/${compilepkg}"

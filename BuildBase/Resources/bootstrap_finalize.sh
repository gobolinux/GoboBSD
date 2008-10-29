#!/bin/sh

umask 022

if [ ! -f "${bootstrapScriptsDir}/bootstrap_finalize.sh" ]; then
  echo Please execute "$0" from its directory
  exit 201
fi

export PYTHONPATH="${ROOT}/System/Links/Libraries/python2.3/site-packages:${ROOT}/System/Links/Libraries/python2.4/site-packages:${ROOT}/System/Links/Libraries/python2.5/site-packages${PYTHONPATH:+:$PYTHONPATH}"
echo ----------------------------------------
echo PATH is $PATH
echo ----------------------------------------
sleep 3

# Fix some stuff that can only be done by superuser
chown 0:0 ${bootstrapDest}/bin/sudo
chmod 4111 ${bootstrapDest}/bin/sudo
chown 0:0 ${bootstrapDest}/etc/sudoers
chmod 0440 ${bootstrapDest}/etc/sudoers

# Scripts will provide install for us
tar -xf src/Scripts--2.9.5--i686.tar.bz2 -C ${ROOT}/Programs

cd ${ROOT}/Programs/Scripts/*
SCRIPTPROGDIR=$(pwd)
SCRIPTPROGVER=$(basename $SCRIPTPROGDIR)

if [ -f ${bootstrapScriptsDir}/Scripts-${SCRIPTPROGVER}*.patch ]; then
  for f in ${bootstrapScriptsDir}/Scripts-${SCRIPTPROGVER}*.patch; do
    patch -Np2 < $f
  done
fi

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
echo "import site" > ${bootstrapDest}/lib/python2.5/sitecustomize.py
echo 'site.addsitedir("/System/Links/Libraries/python2.5/site-packages/")' >> ${bootstrapDest}/lib/python2.5/sitecustomize.py
echo 'site.addsitedir("/System/Links/Libraries/python2.4/site-packages/")' >> ${bootstrapDest}/lib/python2.5/sitecustomize.py
echo 'site.addsitedir("/System/Links/Libraries/python2.3/site-packages/")' >> ${bootstrapDest}/lib/python2.5/sitecustomize.py


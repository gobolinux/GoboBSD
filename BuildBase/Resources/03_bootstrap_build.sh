#!/bin/sh

umask 022

SCRIPTDIR=$(pwd)
if [ ! -f "${SCRIPTDIR}/03_bootstrap_build.sh" ]; then
  echo Please execute $0 from its directory
  exit
fi

ROOT=
PROGBASE=${ROOT}/Programs/Bootstrap
PROGVER=1.0
PROGDEST=${PROGBASE}/${PROGVER}

export PATH=${PROGDEST}/bin:${SCRIPTDIR}/tmptools/bin:$PATH
export LD_LIBRARY_PATH=${PROGDEST}/lib:${SCRIPTDIR}/tmptools/lib:$LD_LIBRARY_PATH
echo ---------------------------------------------------
echo PATH is $PATH
echo LD_LIBRARY_PATH is $LD_LIBRARY_PATH
echo DESTDIR is $DESTDIR
echo HOME is $HOME
echo USER is $USER
echo ---------------------------------------------------
sleep 3

if [ ! -d build ]; then
  mkdir build
fi
if [ ! -L ${PROGBASE}/Current ]; then
  ln -s ${PROGVER} ${PROGBASE}/Current
fi

if [ ! -x ${PROGDEST}/bin/sed ]; then
  echo ---------------------------------------------------
  echo Sed
  echo ---------------------------------------------------
  if [ ! -d build/sed-4.1.5 ]; then
    tar -xzf src/sed-4.1.5.tar.gz -C build
  fi
  cd build/sed-4.1.5
  for f in ../../sed-*.patch; do
    patch -Np1 < $f
  done
  ./configure --prefix=${PROGDEST}
  make
  cp sed/sed ${PROGDEST}/bin/sed
  strip ${PROGDEST}/bin/sed

  if [ ! -x $PROGDEST/bin/sed ]; then
    exit
  fi
  cd ../..
fi

if [ ! -x ${PROGDEST}/bin/lzcat ]; then
  echo ---------------------------------------------------
  echo LZMA 
  echo ---------------------------------------------------
  if [ ! -d build/lzma-4.32.5 ]; then
    tar -xzf src/lzma-4.32.5.tar.gz -C build
  fi
  cd build/lzma-4.32.5
  ./configure --prefix=${PROGDEST} && make && make install
  
  if [ ! -x ${PROGDEST}/bin/lzcat ]; then
    exit
  fi
  cd ../..
fi

if [ ! -x ${PROGDEST}/bin/readlink ]; then
  echo ---------------------------------------------------
  echo CoreUtils
  echo ---------------------------------------------------
  if [ ! -d build/coreutils-6.12 ]; then
    ${PROGDEST}/bin/lzcat src/coreutils-6.12.tar.lzma | tar xf - -C build
  fi
  cd build/coreutils-6.12
#  ./configure --prefix=$PROGDEST --program-prefix=g && make && make install
  ./configure --prefix=${PROGDEST} && make && make install

  if [ ! -x ${PROGDEST}/bin/readlink ]; then
    exit
  fi

  rm ${PROGDEST}/bin/chcon
  rm ${PROGDEST}/bin/runcon
  rm ${PROGDEST}/bin/who
  rm ${PROGDEST}/bin/whoami
  mv ${PROGDEST}/bin/install ${PROGDEST}/bin/real_install

  cd ../..
fi

if [ ! -x ${PROGDEST}/bin/find ]; then
  echo ---------------------------------------------------
  echo FindUtils
  echo ---------------------------------------------------
  if [ ! -d build/findutils-4.4.0 ]; then
    tar -xzf src/findutils-4.4.0.tar.gz -C build
  fi
  cd build/findutils-4.4.0

  ./configure --prefix=${PROGDEST} && make && make install
  if [ ! -x ${PROGDEST}/bin/find ]; then
    exit
  fi
  cd ../..
fi

if [ ! -x ${PROGDEST}/bin/diff ]; then
  echo ---------------------------------------------------
  echo DiffUtils
  echo ---------------------------------------------------
  if [ ! -d build/diffutils-2.8.1 ]; then
    tar -xzf src/diffutils-2.8.1.tar.gz -C build
  fi
  cd build/diffutils-2.8.1
  ./configure --prefix=${PROGDEST} && make && make install

  if [ ! -x ${PROGDEST}/bin/diff ]; then
    exit
  fi
  cd ../..
fi

#if [ ! -x ${PROGDEST}/bin/bison ]; then
#  echo ---------------------------------------------------
#  echo Bison
#  echo ---------------------------------------------------
#  if [ ! -d build/bison ]; then
#    tar -xzf src/bison.tar.gz -C build
#  fi
#  cd build/bison
#  ./configure --prefix=${PROGDEST} && make && make install
#
#  if [ ! -x ${PROGDEST}/bin/bison ]; then
#    exit
#  fi
#  cd ../..
#fi

if [ ! -x ${PROGDEST}/bin/perl ]; then
  echo ---------------------------------------------------
  echo Perl
  echo ---------------------------------------------------
  if [ ! -d build/perl-5.10.0 ]; then
    tar -xzf src/perl-5.10.0.tar.gz -C build
  fi
  cd build/perl-5.10.0
  sh Configure -de -Dcc=gcc -Duselargefiles -Uusesfio -Dprefix=${PROGDEST} -Dinstallusrbinperl=n -Duseshrplib -Dlibperl='libperl.so.5.10' -Dlibpth="/System/Links/Libraries ${PROGDEST}/lib" cf_by='GoboLinux' && make && make install &&
  (eval $(${PROGDEST}/bin/perl -V:archlibexp);
  ln -s libperl.so.5.10 "${archlibexp}/CORE/libperl.so.5";
  ln -s libperl.so.5.10 "${archlibexp}/CORE/libperl.so")

  if [ ! -x ${PROGDEST}/bin/perl ]; then
    exit
  fi
  cd ../..
fi

if [ ! -x ${PROGDEST}/bin/automake ]; then
  echo ---------------------------------------------------
  echo Automake
  echo ---------------------------------------------------
  if [ ! -d build/automake-1.10.1 ]; then
    ${PROGDEST}/bin/lzcat src/automake-1.10.1.tar.lzma | tar xf - -C build
  fi
  cd build/automake-1.10.1
  ./configure --prefix=${PROGDEST} && make && make install

  if [ ! -x ${PROGDEST}/bin/diff ]; then
    exit
  fi
  cd ../..
fi

if [ ! -x ${PROGDEST}/bin/grep ]; then
  echo ---------------------------------------------------
  echo Grep
  echo ---------------------------------------------------
  if [ ! -d build/grep-2.5.3 ]; then
    tar -xjf src/grep-2.5.3.tar.bz2 -C build
  fi
  cd build/grep-2.5.3
  for f in ../../grep-*.patch; do
    patch -Np1 < $f
  done

  ./configure --prefix=${PROGDEST} && make && make install

  if [ ! -x ${PROGDEST}/bin/grep ]; then
    exit
  fi
  cd ../..
fi

if [ ! -x ${PROGDEST}/bin/bash ]; then
  echo ---------------------------------------------------
  echo Bash
  echo ---------------------------------------------------
  if [ ! -d build/bash-3.2 ]; then
    tar -xzf src/bash-3.2.tar.gz -C build
  fi
  cd build/bash-3.2
  ./configure --prefix=$PROGDEST && make && make install

  if [ ! -x ${PROGDEST}/bin/bash ]; then
    exit
  fi
  cd ../..
fi

if [ ! -x ${PROGDEST}/bin/sudo ]; then
  echo ---------------------------------------------------
  echo Sudo
  echo ---------------------------------------------------
  if [ ! -d build/sudo-1.6.9p15 ]; then
    tar -xzf src/sudo-1.6.9p15.tar.gz -C build
  fi
  cd build/sudo-1.6.9p15
  ./configure --prefix=$PROGDEST --with-runas-default="#0" --without-sendmail --with-mailto="" --with-stow --with-env-editor && make && make install

  if [ ! -x ${PROGDEST}/bin/sudo ]; then
    exit
  fi
  cd ../..
fi

if [ ! -x ${PROGDEST}/bin/wget ]; then
  echo ---------------------------------------------------
  echo Wget
  echo ---------------------------------------------------
  if [ ! -d build/wget-1.11.4 ]; then
    tar -xzf src/wget-1.11.4.tar.gz -C build
  fi
  cd build/wget-1.11.4
  ./configure --prefix=$PROGDEST && make && make install

  if [ ! -x ${PROGDEST}/bin/wget ]; then
    exit
  fi
  cd ../..
fi

if [ ! -x ${PROGDEST}/bin/python ]; then
  echo ---------------------------------------------------
  echo Python
  echo ---------------------------------------------------
  if [ ! -d build/python-2.5.2 ]; then
    tar -xjf src/Python-2.5.2.tar.bz2 -C build
  fi
  cd build/Python-2.5.2
  ./configure --prefix=$PROGDEST && make && make install

  if [ ! -x ${PROGDEST}/bin/python ]; then
    exit
  fi
  cd ../..
fi

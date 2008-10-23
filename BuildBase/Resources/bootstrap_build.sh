#!/bin/sh

umask 022

bootstrapScriptsDir=$(pwd)
if [ ! -f "${bootstrapScriptsDir}/bootstrap_build.sh" ]; then
  echo Please execute $0 from its directory
  exit 201
fi

. ./bootstrap_env.inc

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
if [ ! -L ${bootstrapBase}/Current ]; then
  ln -s ${bootstrapVersion} ${bootstrapBase}/Current
fi

if [ ! -x ${bootstrapDest}/bin/sed ]; then
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
  ./configure --prefix=${bootstrapDest}
  make
  cp sed/sed ${bootstrapDest}/bin/sed
  strip ${bootstrapDest}/bin/sed

  if [ ! -x $bootstrapDest/bin/sed ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/lzcat ]; then
  echo ---------------------------------------------------
  echo LZMA 
  echo ---------------------------------------------------
  if [ ! -d build/lzma-4.32.5 ]; then
    tar -xzf src/lzma-4.32.5.tar.gz -C build
  fi
  cd build/lzma-4.32.5
  ./configure --prefix=${bootstrapDest} && make && make install
  
  if [ ! -x ${bootstrapDest}/bin/lzcat ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/readlink ]; then
  echo ---------------------------------------------------
  echo CoreUtils
  echo ---------------------------------------------------
  if [ ! -d build/coreutils-6.12 ]; then
    ${bootstrapDest}/bin/lzcat src/coreutils-6.12.tar.lzma | tar xf - -C build
  fi
  cd build/coreutils-6.12
#  ./configure --prefix=$bootstrapDest --program-prefix=g && make && make install
  ./configure --prefix=${bootstrapDest} && make && make install

  if [ ! -x ${bootstrapDest}/bin/readlink ]; then
    exit 200
  fi

  rm ${bootstrapDest}/bin/chcon
  rm ${bootstrapDest}/bin/runcon
#  rm ${bootstrapDest}/bin/who
#  rm ${bootstrapDest}/bin/whoami
  mv ${bootstrapDest}/bin/install ${bootstrapDest}/bin/real_install

  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/find ]; then
  echo ---------------------------------------------------
  echo FindUtils
  echo ---------------------------------------------------
  if [ ! -d build/findutils-4.4.0 ]; then
    tar -xzf src/findutils-4.4.0.tar.gz -C build
  fi
  cd build/findutils-4.4.0

  ./configure --prefix=${bootstrapDest} && make && make install
  if [ ! -x ${bootstrapDest}/bin/find ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/diff ]; then
  echo ---------------------------------------------------
  echo DiffUtils
  echo ---------------------------------------------------
  if [ ! -d build/diffutils-2.8.1 ]; then
    tar -xzf src/diffutils-2.8.1.tar.gz -C build
  fi
  cd build/diffutils-2.8.1
  ./configure --prefix=${bootstrapDest} && make && make install

  if [ ! -x ${bootstrapDest}/bin/diff ]; then
    exit 200
  fi
  cd ../..
fi

#if [ ! -x ${bootstrapDest}/bin/bison ]; then
#  echo ---------------------------------------------------
#  echo Bison
#  echo ---------------------------------------------------
#  if [ ! -d build/bison ]; then
#    tar -xzf src/bison.tar.gz -C build
#  fi
#  cd build/bison
#  ./configure --prefix=${bootstrapDest} && make && make install
#
#  if [ ! -x ${bootstrapDest}/bin/bison ]; then
#    exit
#  fi
#  cd ../..
#fi

if [ ! -x ${bootstrapDest}/bin/perl ]; then
  echo ---------------------------------------------------
  echo Perl
  echo ---------------------------------------------------
  if [ ! -d build/perl-5.10.0 ]; then
    tar -xzf src/perl-5.10.0.tar.gz -C build
  fi
  cd build/perl-5.10.0
  sh Configure -de -Dcc=gcc -Duselargefiles -Uusesfio -Dprefix=${bootstrapDest} -Dinstallusrbinperl=n -Duseshrplib -Dlibperl='libperl.so.5.10' -Dlibpth="/System/Links/Libraries ${bootstrapDest}/lib" cf_by='GoboLinux' && make && make install &&
  (eval $(${bootstrapDest}/bin/perl -V:archlibexp);
  ln -s libperl.so.5.10 "${archlibexp}/CORE/libperl.so.5";
  ln -s libperl.so.5.10 "${archlibexp}/CORE/libperl.so")

  if [ ! -x ${bootstrapDest}/bin/perl ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/m4 ]; then
  echo ---------------------------------------------------
  echo M4
  echo ---------------------------------------------------
  if [ ! -d build/m4-1.4.11 ]; then
    ${bootstrapDest}/bin/lzcat src/m4-1.4.11.tar.lzma | tar xf - -C build
  fi
  cd build/m4-1.4.11
  ./configure --prefix=${bootstrapDest} && make && make install

  if [ ! -x ${bootstrapDest}/bin/m4 ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/autoconf ]; then
  echo ---------------------------------------------------
  echo Autoconf
  echo ---------------------------------------------------
  if [ ! -d build/autoconf-2.62 ]; then
    ${bootstrapDest}/bin/lzcat src/autoconf-2.62.tar.lzma | tar xf - -C build
  fi
  cd build/autoconf-2.62
  ./configure --prefix=${bootstrapDest} && make && make install
  
  if [ ! -x ${bootstrapDest}/bin/autoconf ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/automake ]; then
  echo ---------------------------------------------------
  echo Automake
  echo ---------------------------------------------------
  if [ ! -d build/automake-1.10.1 ]; then
    ${bootstrapDest}/bin/lzcat src/automake-1.10.1.tar.lzma | tar xf - -C build
  fi
  cd build/automake-1.10.1
  ./configure --prefix=${bootstrapDest} && make && make install

  if [ ! -x ${bootstrapDest}/bin/automake ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/libtool ]; then
  echo ---------------------------------------------------
  echo LibTool
  echo ---------------------------------------------------
  if [ ! -d build/libtool-2.2.6 ]; then
    ${bootstrapDest}/bin/lzcat src/libtool-2.2.6a.tar.lzma | tar xf - -C build
  fi
  cd build/libtool-2.2.6
  ./configure --prefix=${bootstrapDest} && make && make install

  if [ ! -x ${bootstrapDest}/bin/libtool ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/pcre-config ]; then
  echo ---------------------------------------------------
  echo PCRE
  echo ---------------------------------------------------
  if [ ! -d build/pcre-7.7 ]; then
    tar -xjf src/pcre-7.7.tar.bz2 -C build
  fi
  cd build/pcre-7.7
  ./configure --prefix=${bootstrapDest} && make && make install

  if [ ! -x ${bootstrapDest}/bin/pcre-config ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/grep ]; then
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

  ./autogen.sh && \
  ./configure --prefix=${bootstrapDest} && make && \
  cp ${bootstrapDest}/share/automake-*/mkinstalldirs . && make install

  if [ ! -x ${bootstrapDest}/bin/grep ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/bash ]; then
  echo ---------------------------------------------------
  echo Bash
  echo ---------------------------------------------------
  if [ ! -d build/bash-3.2 ]; then
    tar -xzf src/bash-3.2.tar.gz -C build
  fi
  cd build/bash-3.2
  ./configure --prefix=$bootstrapDest && make && make install

  if [ ! -x ${bootstrapDest}/bin/bash ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/sudo ]; then
  echo ---------------------------------------------------
  echo Sudo
  echo ---------------------------------------------------
  if [ ! -d build/sudo-1.6.9p15 ]; then
    tar -xzf src/sudo-1.6.9p15.tar.gz -C build
  fi
  cd build/sudo-1.6.9p15
  ./configure --prefix=$bootstrapDest --with-runas-default="#0" --without-sendmail --with-mailto="" --with-stow --with-env-editor && make && make install

  if [ ! -x ${bootstrapDest}/bin/sudo ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/wget ]; then
  echo ---------------------------------------------------
  echo Wget
  echo ---------------------------------------------------
  if [ ! -d build/wget-1.11.4 ]; then
    tar -xzf src/wget-1.11.4.tar.gz -C build
  fi
  cd build/wget-1.11.4
  for f in ../../wget-*.patch; do
    patch -Np1 < $f
  done
  ./configure --prefix=$bootstrapDest && make && make install

  if [ ! -x ${bootstrapDest}/bin/wget ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/python ]; then
  echo ---------------------------------------------------
  echo Python
  echo ---------------------------------------------------
  if [ ! -d build/python-2.5.2 ]; then
    tar -xjf src/Python-2.5.2.tar.bz2 -C build
  fi
  cd build/Python-2.5.2
  ./configure --prefix=$bootstrapDest && make && make install

  if [ ! -x ${bootstrapDest}/bin/python ]; then
    exit 200
  fi
  cd ../..
fi

if [ ! -x ${bootstrapDest}/bin/gmake ]; then
  echo ---------------------------------------------------
  echo Make
  echo ---------------------------------------------------
  if [ ! -d build/make-3.81 ]; then
    tar -xjf src/make-3.81.tar.bz2 -C build
  fi
  cd build/make-3.81
  ./configure --prefix=$bootstrapDest --program-prefix=g && make && make install

  if [ ! -x ${bootstrapDest}/bin/gmake ]; then
    exit 200
  fi
  ln -s gmake ${bootstrapDest}/bin/make

  cd ../..
fi

exit 0

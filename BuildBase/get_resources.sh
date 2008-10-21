#!/bin/sh -v

cd $(dirname $(which $0))
SCRIPTDIR=$(pwd)

. create_env.inc

RESOURCEDIR=${SCRIPTDIR}/Resources
ftpGnu=ftp://ftp.gnu.org/gnu

if [ ! -d ${RESOURCEDIR}/src ]; then
  mkdir ${RESOURCEDIR}/src
fi

if [ ! -d ${RESOURCEDIR}/tmptools ]; then
  mkdir ${RESOURCEDIR}/tmptools
fi

if [ ! -d ${RESOURCEDIR}/tmptools/bin ]; then
  mkdir ${RESOURCEDIR}/tmptools/bin
fi

if [ ! -d ${RESOURCEDIR}/tmptools/lib ]; then
  mkdir ${RESOURCEDIR}/tmptools/lib
fi

cd ${RESOURCEDIR}/src

BASEURL="$ftpGnu/bash/"
PKG="bash-3.2.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG}
fi

BASEURL="$ftpGnu/sed/"
PKG="sed-4.1.5.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG}
fi

BASEURL="$ftpGnu/coreutils/"
PKG="coreutils-6.12.tar.lzma"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG}
fi

BASEURL="http://tukaani.org/lzma/"
PKG="lzma-4.32.5.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG}
fi

BASEURL="http://www.sudo.ws/sudo/dist/"
PKG="sudo-1.6.9p15.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG}
fi

BASEURL="http://python.org/ftp/python/2.5.2/"
PKG="Python-2.5.2.tar.bz2"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG}
fi

BASEURL="$ftpGnu/findutils/"
PKG="findutils-4.4.0.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG}
fi

BASEURL="$ftpGnu/diffutils/"
PKG="diffutils-2.8.1.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG}
fi

#BASEURL="$ftpGnu/grep/"
#PKG="grep-2.5.3.tar.bz2"
#if [ ! -f $PKG ]; then
#  fetch ${BASEURL}${PKG}
#fi

BASEURL="$ftpGnu/wget/"
PKG="wget-1.11.4.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG}
fi

BASEURL="$ftpGnu/automake/"
PKG="automake-1.10.1.tar.lzma"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG}
fi

BASEURL="http://www.perl.com/CPAN/src/"
PKG="perl-5.10.0.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG}
fi

BASEURL="$ftpGnu/autoconf/"
PKG="autoconf-2.62.tar.lzma"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG}
fi

cd ..

if [ ! -d ${DESTDIR} ]; then
  echo Directory \"${DESTDIR}\" does not exist.
  echo Run create_rootdir.sh first.
  exit
fi

tar cf - -C ${DESTDIR}/usr/bin grep egrep fgrep diff | tar xpf - -C tmptools/bin

TMPTOOLLIBS='libgnuregex*'
TMPTOOLLIBS=$(cd ${DESTDIR}/usr/lib; echo ${TMPTOOLLIBS})
tar cf - -C ${DESTDIR}/usr/lib $TMPTOOLLIBS | tar xpf - -C tmptools/lib

mkdir ${ROOTDIR}/System/Variable/tmp/bootstrap
tar cf - -C ${RESOURCEDIR} . | tar xpf - -C ${ROOTDIR}/System/Variable/tmp/bootstrap
chmod u+x ${ROOTDIR}/System/Variable/tmp/bootstrap/*.sh

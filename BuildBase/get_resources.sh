#!/bin/sh

cd $(dirname $(which $0))
SCRIPTDIR=$(pwd)

. create_env.inc

ftpGnu=ftp://ftp.gnu.org/gnu

if [ ! -d ./Sources ]; then
  mkdir ./Sources || exit 1
fi

cd ./Sources

BASEURL="$ftpGnu/bash/"
PKG="bash-3.2.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="$ftpGnu/sed/"
PKG="sed-4.1.5.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="$ftpGnu/coreutils/"
PKG="coreutils-6.12.tar.lzma"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="http://tukaani.org/lzma/"
PKG="lzma-4.32.5.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="http://www.sudo.ws/sudo/dist/"
PKG="sudo-1.6.9p15.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="http://python.org/ftp/python/2.6/"
PKG="Python-2.6.tar.bz2"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="$ftpGnu/findutils/"
PKG="findutils-4.4.0.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="$ftpGnu/diffutils/"
PKG="diffutils-2.8.1.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="$ftpGnu/grep/"
PKG="grep-2.5.3.tar.bz2"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="$ftpGnu/wget/"
PKG="wget-1.11.4.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="$ftpGnu/automake/"
PKG="automake-1.10.1.tar.lzma"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="http://www.perl.com/CPAN/src/"
PKG="perl-5.10.0.tar.gz"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="$ftpGnu/autoconf/"
PKG="autoconf-2.62.tar.lzma"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="$ftpGnu/m4/"
PKG="m4-1.4.11.tar.lzma"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="$ftpGnu/libtool/"
PKG="libtool-2.2.6a.tar.lzma"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/"
PKG="pcre-7.7.tar.bz2"
if [ ! -f $PKG ]; then
  fetch ${BASEURL}${PKG} || exit 1
fi

BASEURL="http://kundor.org/gobo/packages/official/"
PKG="Scripts--2.9.5--i686.tar.bz2"
if [ ! -f ${PKG} ]; then
  fetch -o ${PKG} ${BASEURL}${PKG} || exit 1
fi

BASEURL="http://kundor.org/gobo/packages/official/"
PKG="Compile--1.11.3--i686.tar.bz2"
if [ ! -f ${PKG} ]; then
  fetch -o ${PKG} ${BASEURL}${PKG} || exit 1
fi

BASEURL="$ftpGnu/make/"
PKG="make-3.81.tar.bz2"
if [ ! -f ${PKG} ]; then
  fetch -o ${PKG} ${BASEURL}${PKG} || exit 1
fi

BASEURL="http://www.openssl.org/source/"
PKG="openssl-0.9.8i.tar.gz"
if [ ! -f ${PKG} ]; then
  fetch -o ${PKG} ${BASEURL}${PKG} || exit 1
fi

exit 0

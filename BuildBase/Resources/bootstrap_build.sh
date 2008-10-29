#!/bin/sh

umask 022

if [ ! -f "${bootstrapScriptsDir}/bootstrap_build.sh" ]; then
  echo "Please execute $0 from its directory"
  exit 201
fi

echo ---------------------------------------------------
echo PATH is ${PATH}
echo LD_LIBRARY_PATH is ${LD_LIBRARY_PATH}
echo DESTDIR is ${DESTDIR}
echo HOME is ${HOME}
echo USER is ${USER}
echo ---------------------------------------------------
sleep 5

if [ ! -d build ]; then
  mkdir build
fi
if [ ! -L ${bootstrapBase}/Current ]; then
  ln -s ${bootstrapVersion} ${bootstrapBase}/Current
fi

if [ ! \( -x ${bootstrapDest}/bin/gsed -a -L ${bootstrapDest}/bin/sed \) ]; then
  echo ---------------------------------------------------
  echo Sed
  echo ---------------------------------------------------
  if [ ! -x ${bootstrapDest}/bin/gsed ]; then
    if [ ! -d build/sed-4.1.5 ]; then
      tar -xzf src/sed-4.1.5.tar.gz -C build
    fi
    cd build/sed-4.1.5
    for f in ../../sed-*.patch; do
      patch -Np1 < $f
    done
    ./configure --prefix=${bootstrapDest}
    make
    cp sed/sed ${bootstrapDest}/bin/gsed
    strip ${bootstrapDest}/bin/gsed
  fi

  if [ ! -x ${bootstrapDest}/bin/gsed ]; then
    exit 200
  fi

  ln -sf gsed ${bootstrapDest}/bin/sed
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

if [ ! \( -x ${bootstrapDest}/bin/greadlink -a -L ${bootstrapDest}/bin/readlink \) ]; then
  echo ---------------------------------------------------
  echo CoreUtils
  echo ---------------------------------------------------
  if [ ! -x ${bootstrapDest}/bin/greadlink ]; then
    if [ ! -d build/coreutils-6.12 ]; then
      ${bootstrapDest}/bin/lzcat src/coreutils-6.12.tar.lzma | tar xf - -C build
    fi
    cd build/coreutils-6.12
    ./configure --prefix=$bootstrapDest --program-prefix=g && \
      make && make install
  fi

  if [ ! -x ${bootstrapDest}/bin/greadlink ]; then
    exit 200
  fi

  if [ -e ${bootstrapDest}/bin/gchcon ]; then
    rm ${bootstrapDest}/bin/gchcon
  fi

  if [ -e ${bootstrapDest}/bin/gruncon ]; then
    rm ${bootstrapDest}/bin/gruncon
  fi

  if [ -e ${bootstrapDest}/bin/ginstall ]; then
    mv ${bootstrapDest}/bin/ginstall ${bootstrapDest}/bin/real_install
  fi

  # Uses system's uname, df (wrong results with coreutils),
  # du (may switch to coreutils when tried it further),
  # id, users, groups, who, whoami, sync, su
  # Also, pinky is not symlinked from gpinky for now...
  ln -sf gls ${bootstrapDest}/bin/ls
  ln -sf gdircolors ${bootstrapDest}/bin/dircolors
  ln -sf gdir ${bootstrapDest}/bin/dir
  ln -sf gvdir ${bootstrapDest}/bin/vdir

  ln -sf gchgrp ${bootstrapDest}/bin/chgrp
  ln -sf gchmod ${bootstrapDest}/bin/chmod
  ln -sf gchown ${bootstrapDest}/bin/chown
  ln -sf gcp ${bootstrapDest}/bin/cp
  ln -sf gdd ${bootstrapDest}/bin/dd
  ln -sf glink ${bootstrapDest}/bin/link
  ln -sf gln ${bootstrapDest}/bin/ln
  ln -sf gmkdir ${bootstrapDest}/bin/mkdir
  ln -sf gmknod ${bootstrapDest}/bin/mknod
  ln -sf gmkfifo ${bootstrapDest}/bin/mkfifo
  ln -sf gmktemp ${bootstrapDest}/bin/mktemp
  ln -sf gmv ${bootstrapDest}/bin/mv
  ln -sf grm ${bootstrapDest}/bin/rm
  ln -sf grmdir ${bootstrapDest}/bin/rmdir
  ln -sf gshred ${bootstrapDest}/bin/shred
  ln -sf gtouch ${bootstrapDest}/bin/touch
  ln -sf gunlink ${bootstrapDest}/bin/unlink

  ln -sf g\[ ${bootstrapDest}/bin/\[
  ln -sf gbase64 ${bootstrapDest}/bin/base64
  ln -sf gbasename ${bootstrapDest}/bin/basename
  ln -sf gchroot ${bootstrapDest}/bin/chroot
  ln -sf gcksum ${bootstrapDest}/bin/cksum
  ln -sf gcat ${bootstrapDest}/bin/cat
  ln -sf gchroot ${bootstrapDest}/bin/chroot
  ln -sf gcomm ${bootstrapDest}/bin/comm
  ln -sf gcsplit ${bootstrapDest}/bin/csplit
  ln -sf gcut ${bootstrapDest}/bin/cut
  ln -sf gdate ${bootstrapDest}/bin/date
  ln -sf gdirname ${bootstrapDest}/bin/dirname
  ln -sf gecho ${bootstrapDest}/bin/echo
  ln -sf genv ${bootstrapDest}/bin/env
  ln -sf gexpr ${bootstrapDest}/bin/expr
  ln -sf gexpand ${bootstrapDest}/bin/expand
  ln -sf gfactor ${bootstrapDest}/bin/factor
  ln -sf gfalse ${bootstrapDest}/bin/false
  ln -sf gfold ${bootstrapDest}/bin/fold
  ln -sf gfmt ${bootstrapDest}/bin/fmt
  ln -sf ghead ${bootstrapDest}/bin/head
  ln -sf ghostid ${bootstrapDest}/bin/hostid
  ln -sf gjoin ${bootstrapDest}/bin/join
  ln -sf gkill ${bootstrapDest}/bin/kill
  ln -sf god ${bootstrapDest}/bin/od
  ln -sf gmd5sum ${bootstrapDest}/bin/md5sum
  ln -sf gnice ${bootstrapDest}/bin/nice
  ln -sf gnl ${bootstrapDest}/bin/nl
  ln -sf gnohup ${bootstrapDest}/bin/nohup
  ln -sf gpaste ${bootstrapDest}/bin/paste
  ln -sf gpathchk ${bootstrapDest}/bin/pathchk
  ln -sf gpr ${bootstrapDest}/bin/pr
  ln -sf gprintenv ${bootstrapDest}/bin/printenv
  ln -sf gprintf ${bootstrapDest}/bin/printf
  ln -sf gptx ${bootstrapDest}/bin/ptx
  ln -sf gpwd ${bootstrapDest}/bin/pwd
  ln -sf greadlink ${bootstrapDest}/bin/readlink
  ln -sf gseq ${bootstrapDest}/bin/seq
  ln -sf gsetuidgid ${bootstrapDest}/bin/setuidgid
  ln -sf gsha1sum ${bootstrapDest}/bin/sha1sum
  ln -sf gsha224sum ${bootstrapDest}/bin/sha224sum
  ln -sf gsha256sum ${bootstrapDest}/bin/sha256sum
  ln -sf gsha384sum ${bootstrapDest}/bin/sha384sum
  ln -sf gsha512sum ${bootstrapDest}/bin/sha512sum
  ln -sf gshuf ${bootstrapDest}/bin/shuf
  ln -sf gsleep ${bootstrapDest}/bin/sleep
  ln -sf gsort ${bootstrapDest}/bin/sort
  ln -sf gstat ${bootstrapDest}/bin/stat
  ln -sf gstty ${bootstrapDest}/bin/stty
  ln -sf gsplit ${bootstrapDest}/bin/split
  ln -sf gsum ${bootstrapDest}/bin/sum
  ln -sf gtac ${bootstrapDest}/bin/tac
  ln -sf gtail ${bootstrapDest}/bin/tail
  ln -sf gtee ${bootstrapDest}/bin/tee
  ln -sf gtest ${bootstrapDest}/bin/test
  ln -sf gtr ${bootstrapDest}/bin/tr
  ln -sf gtrue ${bootstrapDest}/bin/true
  ln -sf gtsort ${bootstrapDest}/bin/tsort
  ln -sf gtty ${bootstrapDest}/bin/tty
  ln -sf gunexpand ${bootstrapDest}/bin/unexpand
  ln -sf guniq ${bootstrapDest}/bin/uniq
  ln -sf gwc ${bootstrapDest}/bin/wc
  ln -sf gyes ${bootstrapDest}/bin/yes

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

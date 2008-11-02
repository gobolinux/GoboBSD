#!/bin/sh

cd $(dirname $(which $0))
. create_env.inc

umask 022

if [ -d ${ROOTDIR} ]; then
	./remove_rootdir.sh
fi

mkdir ${ROOTDIR}
mkdir ${ROOTDIR}/Files
mkdir ${ROOTDIR}/Files/Compile
mkdir ${ROOTDIR}/Files/Compile/Archives
mkdir ${ROOTDIR}/Files/Compile/Sources
mkdir ${ROOTDIR}/Files/Compile/Recipes
mkdir ${ROOTDIR}/Mounts
mkdir ${ROOTDIR}/Mounts/CD-ROM
mkdir ${ROOTDIR}/Mounts/Floppy
mkdir ${ROOTDIR}/Mounts/Media
mkdir ${ROOTDIR}/Programs
mkdir ${ROOTDIR}/System
mkdir ${ROOTDIR}/System/Kernel
mkdir ${ROOTDIR}/System/Kernel/Boot
mkdir ${ROOTDIR}/System/Kernel/Devices
mkdir ${ROOTDIR}/System/Kernel/Status
mkdir ${ROOTDIR}/System/Links
mkdir ${ROOTDIR}/System/Links/Environment
mkdir ${ROOTDIR}/System/Links/Executables
mkdir ${ROOTDIR}/System/Links/Headers
mkdir ${ROOTDIR}/System/Links/Libraries
mkdir ${ROOTDIR}/System/Links/Manuals
mkdir ${ROOTDIR}/System/Links/Manuals/man0
mkdir ${ROOTDIR}/System/Links/Manuals/man1
mkdir ${ROOTDIR}/System/Links/Manuals/man2
mkdir ${ROOTDIR}/System/Links/Manuals/man3
mkdir ${ROOTDIR}/System/Links/Manuals/man4
mkdir ${ROOTDIR}/System/Links/Manuals/man5
mkdir ${ROOTDIR}/System/Links/Manuals/man6
mkdir ${ROOTDIR}/System/Links/Manuals/man7
mkdir ${ROOTDIR}/System/Links/Manuals/man8
mkdir ${ROOTDIR}/System/Links/Shared
mkdir ${ROOTDIR}/System/Links/Tasks
mkdir ${ROOTDIR}/System/Settings
mkdir ${ROOTDIR}/System/Variable

# TODO: look into programs that store stuff here
mkdir ${ROOTDIR}/System/Variable/backups

# TODO: look into utils dumpon, savecore
mkdir ${ROOTDIR}/System/Variable/crash

mkdir ${ROOTDIR}/System/Variable/db

# TODO: look into start script that saves entropy
mkdir ${ROOTDIR}/System/Variable/db/entropy

mkdir ${ROOTDIR}/System/Variable/empty
mkdir ${ROOTDIR}/System/Variable/lib
mkdir ${ROOTDIR}/System/Variable/log
mkdir ${ROOTDIR}/System/Variable/mail
mkdir ${ROOTDIR}/System/Variable/run
mkdir ${ROOTDIR}/System/Variable/spool
mkdir ${ROOTDIR}/System/Variable/tmp
mkdir ${ROOTDIR}/usr
mkdir ${ROOTDIR}/Users
mkdir ${ROOTDIR}/Users/root

chmod 555 ${ROOTDIR}/System/Variable/empty
chmod 1777 ${ROOTDIR}/System/Variable/tmp

ln -s System/Links/Executables ${ROOTDIR}/sbin
ln -s System/Links/Executables ${ROOTDIR}/bin
ln -s System/Links/Libraries ${ROOTDIR}/lib
ln -s System/Links/Libraries ${ROOTDIR}/libexec
ln -s . ${ROOTDIR}/usr/X11R6
ln -s ../System/Links/Executables ${ROOTDIR}/usr/bin
ln -s ../System/Links/Headers ${ROOTDIR}/usr/include
ln -s ../System/Links/Libraries ${ROOTDIR}/usr/lib
ln -s ../System/Links/Libraries ${ROOTDIR}/usr/libexec
ln -s . ${ROOTDIR}/usr/local
ln -s ../System/Links/Manuals ${ROOTDIR}/usr/man
ln -s ../System/Links/Executables ${ROOTDIR}/usr/sbin
ln -s ../System/Links/Shared ${ROOTDIR}/usr/share
ln -s /Files/Compile/Sources ${ROOTDIR}/usr/src

ln -s System/Kernel/Boot ${ROOTDIR}/boot
ln -s System/Kernel/Devices ${ROOTDIR}/dev
ln -s System/Kernel/Status ${ROOTDIR}/proc
ln -s System/Settings ${ROOTDIR}/etc
ln -s System/Variable ${ROOTDIR}/var
ln -s System/Variable/tmp ${ROOTDIR}/tmp

mkdir ${BASEDIR}
mkdir ${BASEDIR}/${BSDREL}
ln -s ${BSDREL} ${BASEDIR}/Current
mkdir ${BASEDIR}/Settings
mkdir ${BASEDIR}/${BSDREL}/bin
mkdir ${BASEDIR}/${BSDREL}/lib
mkdir ${BASEDIR}/${BSDREL}/libexec
mkdir ${BASEDIR}/${BSDREL}/Shared
mkdir ${BASEDIR}/${BSDREL}/Shared/misc
mkdir ${BASEDIR}/${BSDREL}/Shared/mk
mkdir ${BASEDIR}/${BSDREL}/Resources
mkdir ${BASEDIR}/${BSDREL}/Resources/Defaults
mkdir ${BASEDIR}/${BSDREL}/Resources/Defaults/Settings
mkdir ${BASEDIR}/${BSDREL}/Resources/Defaults/Settings/skel
mkdir ${TOOLDIR}
mkdir ${TOOLDIR}/${BSDREL}
ln -s ${BSDREL} ${TOOLDIR}/Current
mkdir ${TOOLDIR}/${BSDREL}/bin
mkdir ${TOOLDIR}/${BSDREL}/lib
mkdir ${TOOLDIR}/${BSDREL}/Shared
mkdir ${TOOLDIR}/${BSDREL}/Shared/misc

chown -R 0:0 ${ROOTDIR}

DYNLINKER='ld-elf.so*'
DYNLINKER="$(cd ${DESTDIR}/libexec; echo ${DYNLINKER})"
tar -cf - -C ${DESTDIR}/libexec ${DYNLINKER} | tar -xpf - -C ${BASEDIR}/${BSDREL}/libexec

# This is probably overkill (we only want libc and some other stuff...)
tar -cf - -C ${DESTDIR}/usr include/ | tar -xpf - -C ${BASEDIR}/${BSDREL}

# Stuff needed to build programs
BUILDPROGS="cc gcc as ld ar ranlib nm size strip CC c++ g++ cpp"
BUILDLIBEXEC="cc1 cc1plus"
BUILDLIBS='*.o libstdc++* libc.* libc_* libgcc* libpthread* libthr.so libm.so libcrypt.so'
BUILDLIBS=$(cd ${DESTDIR}/usr/lib; echo ${BUILDLIBS})

# User management
USERMANAGEMENTBINPROGS="cap_mkdb users w whoami id who su groups"
USERMANAGEMENTSBINPROGS="pw pwd_mkdb"
USERMANAGEMENTLIBS='libpam* libutil* libbsm*'
USERMANAGEMENTLIBS=$(cd ${DESTDIR}/usr/lib; echo ${USERMANAGEMENTLIBS})

# Basic tools
TOOLBINPROGS="ipcs ipcrm uname make ldd uptime"
TOOLSBINPROGS=""

# Useful (temporary) tools
TMPTOOLBINPROGS="false true tar bsdtar bzip2 bunzip2 gzip gunzip gzcat patch find sort wc uniq install printf tr awk touch sed byacc yacc grep egrep fgrep cmp diff file less more"
TMPTOOLSBINPROGS="chown"
TMPTOOLLIBS='libbz2* libarchive* libgnuregex* libmagic*'
TMPTOOLLIBS=$(cd ${DESTDIR}/usr/lib; echo ${TMPTOOLLIBS})

# Files from /bin ('.' means everything)
BINPROGS="."

# Files from /sbin ('.' means everything)
SBINPROGS="."

tar -cf - -C ${DESTDIR}/usr/libexec ${BUILDLIBEXEC} \
  -C ${DESTDIR}/usr/lib \
  ${BUILDLIBS} \
  ${USERMANAGEMENTLIBS} \
  ${TOOLLIBS} \
  -C ${DESTDIR}/lib . \
  | tar -xpf - -C ${BASEDIR}/${BSDREL}/lib

tar -cf - -C ${DESTDIR}/usr/bin \
  ${BUILDPROGS} \
  ${USERMANAGEMENTBINPROGS} \
  ${TOOLBINPROGS} \
  -C ${DESTDIR}/usr/sbin \
  ${USERMANAGEMENTSBINPROGS} \
  ${TOOLSBINPROGS} \
  -C ${DESTDIR}/bin ${BINPROGS} \
  -C ${DESTDIR}/sbin ${SBINPROGS} \
  | tar -xpf - -C ${BASEDIR}/${BSDREL}/bin

mv ${BASEDIR}/${BSDREL}/bin/make ${BASEDIR}/${BSDREL}/bin/fmake
ln -s fmake ${BASEDIR}/${BSDREL}/bin/make

tar -cf - -C ${DESTDIR}/usr/bin ${TMPTOOLBINPROGS} \
  -C ${DESTDIR}/usr/sbin ${TMPTOOLSBINPROGS} \
  | tar -xpf - -C ${TOOLDIR}/${BSDREL}/bin

tar -cf - -C ${DESTDIR}/usr/lib ${TMPTOOLLIBS} \
  | tar -xpf - -C ${TOOLDIR}/${BSDREL}/lib

cat > ${BASEDIR}/${BSDREL}/Resources/Defaults/Settings/shells << "EOF"
/bin/bash
/bin/zsh
/bin/csh
/bin/tcsh
/bin/ksh
/bin/rc
/bin/es
/bin/tclsh
/bin/ash
/bin/sash
EOF

cat > ${BASEDIR}/${BSDREL}/Resources/Defaults/Settings/skel/.bash_profile << "EOF"
#!/bin/bash
# When bash is a login shell, this file (.bash_profile) gets sourced.
# When it is not a login shell, .bashrc gets sourced instead.
# To ensure a consistent behavior in all interactive shell instances,
# all this file does is to call .bashrc (which is the file that is executed
# for non-login bash instances).

. ~/.bashrc

# Do not add commands here unless you want them loaded only in login shells
# (ie, those invoked by gettys, not X terminals).
EOF

cat > ${BASEDIR}/${BSDREL}/Resources/Defaults/Settings/skel/.bashrc << "EOF"
#!/bin/bash

. /System/Settings/bashrc

export PATH=$PATH:.
EOF

cat > ${BASEDIR}/${BSDREL}/Resources/Defaults/Settings/skel/.zshrc << "EOF"

alias pico="nano -p"
alias rm="rm -i"
alias cp="cp -i"

prompt lode cyan
EOF

cat > ${BASEDIR}/${BSDREL}/Resources/Defaults/Settings/skel/.toprc << "EOF"
RCfile for "top with windows"           # shameless braggin'
Id:a, Mode_altscr=0, Mode_irixps=1, Delay_time=3.000, Curwin=0
Def	fieldscur=AEHIOQTWKNMbcdfgjplrsuvyzX
	winflags=65337, sortindx=10, maxtasks=0
	summclr=6, msgsclr=6, headclr=2, taskclr=6
Job	fieldscur=ABcefgjlrstuvyzMKNHIWOPQDX
	winflags=64824, sortindx=0, maxtasks=0
	summclr=2, msgsclr=2, headclr=2, taskclr=2
Mem	fieldscur=ANOPQRSTUVbcdefgjlmyzWHIKX
	winflags=64824, sortindx=13, maxtasks=0
	summclr=5, msgsclr=5, headclr=4, taskclr=5
Usr	fieldscur=ABDECGfhijlopqrstuvyzMKNWX
	winflags=64824, sortindx=4, maxtasks=0
	summclr=3, msgsclr=3, headclr=1, taskclr=3
EOF

# Copy default settings
tar -cf - -C ${BASEDIR}/${BSDREL}/Resources/Defaults/Settings . | \
  tar -xpf - -C ${BASEDIR}/Settings

# Copy skeleton directory to superuser's homedir
tar -cf - -C ${BASEDIR}/Settings/skel . | tar -xpf - -C ${ROOTDIR}/Users/root

dirlink()
{
  local fromdir;
  local todir;
  local f;
  
  fromdir="$1";
  todir="$2";

  if [ "x${fromdir}" = "x" ]; then
    return 1
  fi

  if [ "x${todir}" = "x" ]; then
    return 1
  fi

  echo Linking ${fromdir} to ${todir}
  for f in ${ROOTDIR}/${fromdir}/*; do
    ln -s /${fromdir}/$(basename $f) ${ROOTDIR}/${todir}
  done
}

dirlink ${BASE}/${BSDREL}/bin System/Links/Executables
dirlink ${TOOL}/${BSDREL}/bin System/Links/Executables

dirlink ${BASE}/${BSDREL}/lib System/Links/Libraries
dirlink ${TOOL}/${BSDREL}/lib System/Links/Libraries
dirlink ${BASE}/${BSDREL}/libexec System/Links/Libraries

dirlink ${BASE}/${BSDREL}/include System/Links/Headers

dirlink ${BASE}/Settings System/Settings

tar -cf - -C ${DESTDIR}/boot ./boot ./mbr | tar -xpf - -C ${ROOTDIR}/boot/

# Add termcap for Ncurses and magic files for file

MISCFILES='termcap'
MISCFILES=$(cd ${DESTDIR}/usr/share/misc; echo ${MISCFILES})
tar -cf - -C ${DESTDIR}/usr/share/misc ${MISCFILES} | tar -xpf - -C ${BASEDIR}/${BSDREL}/Shared/misc

MISCFILES='magic*'
MISCFILES=$(cd ${DESTDIR}/usr/share/misc; echo ${MISCFILES})
tar -cf - -C ${DESTDIR}/usr/share/misc ${MISCFILES} | tar -xpf - -C ${TOOLDIR}/${BSDREL}/Shared/misc

# Add system include files for freebsd make to work
tar -cf - -C ${DESTDIR}/usr/share/mk . | tar -xpf - -C ${BASEDIR}/${BSDREL}/Shared/mk

# Shared/mk links
mkdir ${ROOTDIR}/System/Links/Shared/mk
dirlink ${BASE}/${BSDREL}/Shared/mk System/Links/Shared/mk

# Shared/misc links
mkdir ${ROOTDIR}/System/Links/Shared/misc
dirlink ${BASE}/${BSDREL}/Shared/misc System/Links/Shared/misc
dirlink ${TOOL}/${BSDREL}/Shared/misc System/Links/Shared/misc

# Add system's default user/group files
tar -cf - -C ${DESTDIR}/etc ./master.passwd ./passwd ./group ./spwd.db ./pwd.db ./login.conf | tar -xpf - -C ${ROOTDIR}/etc

# Need to add this symlink temporarily, until superuser has changed the homedirectory
ln -s /Users/root ${ROOTDIR}

# Copy /etc/resolv.conf from main system
cp /etc/resolv.conf ${ROOTDIR}/etc

cat > ${ROOTDIR}/etc/rc << "EOFRC"
#!/bin/sh -v
VERSION="0.1r1"
trap : 2
trap "echo 'Boot Interrupted'" 3
export PATH=/bin
export TERM=cons25
#mdmfs -s 512k md /System/Variable
#mkdir /System/Variable/db/freebsd-update
#mkdir /System/Variable/db/ipf
#mkdir /System/Variable/db/pkg
#mkdir /System/Variable/db/ports
#mkdir /System/Variable/db/portsnap
mount -o rw /dev/md0 /

/bin/sh
halt
EOFRC

echo "014.01" > ${ROOTDIR}/System/Settings/GoboLinuxVersion

# Run get_resources.sh (should be a no-op if all sources are
# already there)
./get_resources.sh || exit 1

mkdir ${ROOTDIR}/Users/root/bootstrap
tar -cf - -C ./Resources . | tar -xpf - -C ${ROOTDIR}/Users/root/bootstrap
chmod u+x ${ROOTDIR}/Users/root/bootstrap/run_bootstrap.sh

tar -cf - -C ./Sources . | tar -xpf - -C ${ROOTDIR}/Files/Compile/Archives

exit 0

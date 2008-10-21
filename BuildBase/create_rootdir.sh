#!/bin/sh -v

cd $(dirname $(which $0))
. create_env.inc

rm -rf ${ROOTDIR}
mkdir ${ROOTDIR}
mkdir ${ROOTDIR}/Files
mkdir ${ROOTDIR}/Files/Compile
mkdir ${ROOTDIR}/Files/Compile/Archives
mkdir ${ROOTDIR}/Files/Compile/Sources
mkdir ${ROOTDIR}/Programs
mkdir ${ROOTDIR}/System
mkdir ${ROOTDIR}/System/Kernel
mkdir ${ROOTDIR}/System/Kernel/Devices
mkdir ${ROOTDIR}/System/Kernel/Boot
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

ln -s System/Kernel/Devices ${ROOTDIR}/dev
ln -s System/Variable/tmp ${ROOTDIR}/tmp
ln -s System/Variable ${ROOTDIR}/var
ln -s System/Kernel/Boot ${ROOTDIR}/boot
ln -s System/Settings ${ROOTDIR}/etc

mkdir ${BASEDIR}
mkdir ${BASEDIR}/${BASEREL}
ln -s ${BASEREL} ${BASEDIR}/Current
mkdir ${BASEDIR}/Settings
mkdir ${BASEDIR}/${BASEREL}/lib
mkdir ${BASEDIR}/${BASEREL}/bin
mkdir ${BASEDIR}/${BASEREL}/libexec
mkdir ${BASEDIR}/${BASEREL}/Shared
mkdir ${BASEDIR}/${BASEREL}/Shared/misc
mkdir ${BASEDIR}/${BASEREL}/Shared/mk

DYNLINKER='ld-elf.so*'
DYNLINKER="$(cd ${DESTDIR}/libexec; echo ${DYNLINKER})"
tar cf - -C ${DESTDIR}/libexec ${DYNLINKER} | tar xpf - -C ${BASEDIR}/${BASEREL}/libexec

# This is probably overkill (we only want libc and some other stuff...)
tar cf - -C ${DESTDIR}/usr include/ | tar xpf - -C ${BASEDIR}/${BASEREL}

# Stuff needed to build programs
BUILDPROGS="cc gcc as ld ar ranlib nm strip CC c++ g++ cpp"
BUILDLIBEXEC="cc1 cc1plus"
BUILDLIBS='*.o libstdc++* libc.* libc_* libgcc* libpthread* libthr.so libm.so libcrypt.so'
BUILDLIBS=$(cd ${DESTDIR}/usr/lib; echo ${BUILDLIBS})

# User management
USERMANAGEMENTBINPROGS="cap_mkdb whoami who su"
USERMANAGEMENTSBINPROGS="pw pwd_mkdb"
USERMANAGEMENTLIBS='libpam* libutil* libbsm*'
USERMANAGEMENTLIBS=$(cd ${DESTDIR}/usr/lib; echo ${USERMANAGEMENTLIBS})

# Useful tools
TOOLSBINPROGS="false true tar bsdtar ipcs bzip2 bunzip2 gzip gunzip gzcat patch find uname make sort uniq install printf tr awk touch sed byacc yacc grep egrep fgrep file less more"
TOOLSSBINPROGS="chown"
TOOLSLIBS='libbz2* libarchive* libgnuregex* libmagic*'
TOOLSLIBS=$(cd ${DESTDIR}/usr/lib; echo ${TOOLSLIBS})

# Files from /bin ('.' means everything)
BINPROGS="."

# Files from /sbin ('.' means everything)
SBINPROGS="."

tar cf - -C ${DESTDIR}/usr/libexec ${BUILDLIBEXEC} \
  -C ${DESTDIR}/usr/lib \
  ${BUILDLIBS} \
  ${USERMANAGEMENTLIBS} \
  ${TOOLSLIBS} \
  -C ${DESTDIR}/lib . \
  | tar -xpf - -C ${BASEDIR}/${BASEREL}/lib

tar cf - -C ${DESTDIR}/usr/bin \
  ${BUILDPROGS} \
  ${USERMANAGEMENTBINPROGS} \
  ${TOOLSBINPROGS} \
  -C ${DESTDIR}/usr/sbin \
  ${USERMANAGEMENTSBINPROGS} \
  ${TOOLSSBINPROGS} \
  -C ${DESTDIR}/bin ${BINPROGS} \
  -C ${DESTDIR}/sbin ${SBINPROGS} \
  | tar -xpf - -C ${BASEDIR}/${BASEREL}/bin

ln install ${BASEDIR}/${BASEREL}/bin/real_install

cat > ${BASEDIR}/Settings/shells << "EOF"
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

for f in ${ROOTDIR}/${BASE}/${BASEREL}/bin/*; do
	ln -s /${BASE}/${BASEREL}/bin/$(basename $f) ${ROOTDIR}/System/Links/Executables
done
for f in ${ROOTDIR}/${BASE}/${BASEREL}/lib/*; do
	ln -s /${BASE}/${BASEREL}/lib/$(basename $f) ${ROOTDIR}/System/Links/Libraries
done
for f in ${ROOTDIR}/${BASE}/${BASEREL}/libexec/*; do
	ln -s /${BASE}/${BASEREL}/libexec/$(basename $f) ${ROOTDIR}/System/Links/Libraries
done
for f in ${ROOTDIR}/${BASE}/${BASEREL}/include/*; do
	ln -s /${BASE}/${BASEREL}/include/$(basename $f) ${ROOTDIR}/System/Links/Headers
done
for f in ${ROOTDIR}/${BASE}/Settings/*; do
	ln -s /${BASE}/Settings/$(basename $f) ${ROOTDIR}/System/Settings
done

tar cf - -C ${DESTDIR}/boot ./boot ./mbr | tar xpf - -C ${ROOTDIR}/boot/

# Add termcap for Ncurses and magic files for file

MISCFILES='termcap magic*'
MISCFILES=$(cd ${DESTDIR}/usr/share/misc; echo ${MISCFILES})
tar cf - -C ${DESTDIR}/usr/share/misc ${MISCFILES} | tar xpf - -C ${BASEDIR}/${BASEREL}/Shared/misc

# Add system include files for freebsd make to work
tar cf - -C ${DESTDIR}/usr/share/mk . | tar xpf - -C ${BASEDIR}/${BASEREL}/Shared/mk

# Shared/mk links
mkdir ${ROOTDIR}/System/Links/Shared/mk
for f in ${ROOTDIR}/${BASE}/${BASEREL}/Shared/mk/*; do
	ln -s /${BASE}/${BASEREL}/Shared/mk/$(basename $f) ${ROOTDIR}/System/Links/Shared/mk
done

# Shared/misc links
mkdir ${ROOTDIR}/System/Links/Shared/misc
for f in ${ROOTDIR}/${BASE}/${BASEREL}/Shared/misc/*; do
	ln -s /${BASE}/${BASEREL}/Shared/misc/$(basename $f) ${ROOTDIR}/System/Links/Shared/misc
done

# Add system's default user/group files
tar cf - -C ${DESTDIR}/etc ./master.passwd ./passwd ./group ./spwd.db ./pwd.db ./login.conf | tar xpf - -C ${ROOTDIR}/etc

# Need to add this symlink temporarily, until superuser has changed the homedirectory
ln -s /Users/root ${ROOTDIR}

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

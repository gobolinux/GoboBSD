GoboBSD is a project to port GoboLinux distribution to the FreeBSD platform.

At this juncture, a fully working system is not produced.


REQUIREMENTS FOR CREATING A BASIC SYSTEM
========================================
FreeBSD release cdrom
A FreeBSD environment

Optional utilities:
makefs (sysutils/makefs) for create_bootdir.sh
mkisofs (sysutils/cdrtools) for create_cdrom.sh


INSTALL
=======
adapt create_env.inc
mount FreeBSD release cdrom at /cdrom

As superuser, run:
1. create_scratch.sh
2. create_rootdir.sh
3. get_resources.sh
4. enter_chroot.sh
5. /System/Variable/tmp/bootstrap/run_bootstrap.sh

DONE! You now have a basic system.

To optionally create iso-file, quit the chroot and run:
6. create_bootdir.sh
7. create_cdrom.sh myisofile

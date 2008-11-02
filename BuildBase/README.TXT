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
mount FreeBSD release cdrom at /cdrom - this
is the version of FreeBSD that is going to
be installed in the chroot.

As superuser, run:
1. create_scratch.sh
2. get_resources.sh
3. create_rootdir.sh
4. enter_chroot.sh
5. cd /Users/root/bootstrap
6. ./run_bootstrap.sh
7. exit chroot and run create_bootdir.sh

DONE! You now have a basic system. Note that some
system tools in the chroot (needed for Compile/
Scripts) are only guarenteed to work if the main
system runs the same version of FreeBSD as the one
installed into the chroot.

To optionally create iso-file, run:
7. create_cdrom.sh myisofile

#!/bin/sh

# Make sure superuser is using correct home directory
pw usermod -u 0 -c "SuperUser" -d /Users/root

# Add fibo user/group
# Note that since zsh isn't installed yet, sh will
# have to do as shell for now
pw useradd -D -u 1,99 -g ""
pw useradd fibo -c "FiboSandbox user" -d /tmp -s sh
pw useradd -D -u 1000,32000

pw groupadd users -g 100

# Set default base directory for new users
# Require passwords for new users in order to login
# Default shell is sh (will be changed to zsh when
# it has been installed)
# Default primary group is new group named after user
pw useradd -D -b /Users -w no -s sh -g ""

# Remove unneccesary symlink that was setup by create_rootdir.sh
if [ -L /root ]; then
  rm /root
fi

exit 0

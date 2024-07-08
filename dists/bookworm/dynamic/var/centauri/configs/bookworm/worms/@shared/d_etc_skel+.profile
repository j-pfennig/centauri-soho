# This file is executed by most login shells and is optional. It can be
# deleted safely. When deleted the default code will be run automatically
# via /etc/profile by sourcing /etc/bash.centauri:

## Override system default
#LANG="en_US.UTF-8" ; export LANG

## Time in ISO format for qt (e.g. kde) apps. Qt has a built-in en_SE locale.
## to avoid complaints of linux programs, create a fake en_SE locale using the
## following command (as root): localedef -f UTF-8 -i en_US en_SE.UTF-8
#LC_TIME="en_SE.UTF-8" ; export LC_TIME

# perform the default setup (recommended)
. /etc/bash.centauri PROFILE 

# Put your custom code here ...

    # show motd in simple GUI ...
    [ "$EUID" = 0 ] && [ "$TERM" = 'xterm' ] && cat /etc/motd

    # seeding of LxQt
    [ ! -d "$HOME/.config/lxqt" ] && [ -e "$CEN_ROOT/tools/Desktop/lxqt-config.tgz" ] &&
        tar -xaf "$CEN_ROOT/tools/Desktop/lxqt-config.tgz" --directory="$HOME"

# end

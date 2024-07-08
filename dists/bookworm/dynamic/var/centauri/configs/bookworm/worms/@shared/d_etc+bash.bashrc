# jpf@Centauri - modified bash startup
# ------------------------------------------------------------------------
# Bash calls /etc/profile as a login shell and /etc/bash.bashrc as an 
# interactive shell. Usually /etc/profile sources /etc/bash.bashrc .
#
# For centauri the debian /etc/profile, /etc/bash.bashrc and the /etc/.skel
# files are modified.  The user provided .profile and .bashrc skel files are
# optional and serve as documentation only.
#
# /etc/profile                 # tuned, avoid multiple bash_completion
# /etc/bash.bashrc             # modified to call /etc/bash.centauri
# /etc/bash.centauri           # checks for .bashrc and .alias
# ------------------------------------------------------------------------

# echo /etc/bash.bashrc

# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
export COLUMNS LINES

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -s /etc/debian_chroot ]; then
    debian_chroot=$(</etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    function command_not_found_handle {
        # check because c-n-f could've been removed in the meantime
        if [ -x /usr/lib/command-not-found ]; then
            /usr/lib/command-not-found -- "$1"
            return $?
        elif [ -x /usr/share/command-not-found/command-not-found ]; then
            /usr/share/command-not-found/command-not-found -- "$1"
            return $?
        else
            printf "%s: command not found\n" "$1" >&2
            return 127
        fi
    }
fi

############################ jpf@centauri ################################
[ -f /etc/bash.centauri ] && . /etc/bash.centauri INIT
############################ jpf@centauri ################################

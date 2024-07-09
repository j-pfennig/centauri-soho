#!/usr/bin/bash

# ------------------------------------------------------------------------------
# Script to seed current system from github download
# ------------------------------------------------------------------------------

run() {
    # This script i s stupid, also must run as root ...

    [ "$EUID" = 0 ] || quit -e "Must run as root user"
    folder -c -q ~local || quit -e "Cannot find home of 'local' user"

    # protect the development system
    [ -d /admin ] && quit -e "Refusing to run on this system"
    confirm -n "Prepare current system for centauri-soho development" || quit

    # 3) install git and clone 'j-pfennig/centauri-soho':

    [ -x /usr/bin/git ] || { system apt install git || quit ; }
    [ -d centauri-soho ] || { system git clone \
                              https://github.com/j-pfennig/centauri-soho || quit ; }

    # 4) goto centauri-soho/dists/bookworm and copy:

    if [ ! -d /centauritools ] ; then
        folder -c centauri-soho/dists/bookworm || quit
        getent group wheel || { echo 'wheel:x:51' >>/etc/group ; }
        getent passwd pulse || { echo 'pulse:x:505:audio::/run:/usr/sbin/nologin' >>/etc/passwd ; }
        system chown -r root:root .  || quit
        system cp -ra static/* dynamic/* / || quit
    fi

    # 5) goto cenrauri-soho/dists/bookworm to fix ownerships of files:

    folder -c centauri-soho/dists/bookworm || quit
    embed centauriowner --base=. restore OWNERS || quit
    system cp -r --attributes-only static/* dynamic/* / || quit

    quit "Ready for centauri-soho development"
}

# ------------------------------------------------------------------------------
# This tool can be run without centauri-bash-lib being installed. If so it uses
# a couple simplified library equivalents that are created below ...
# ------------------------------------------------------------------------------

[ -z "$CEN_NAME" ] && [ -x '/usr/local/bin/_centauri_bash_lib' ] &&
    . /usr/local/bin/_centauri_bash_lib -a -f - '0.10:2' 0

# ------------------------------------------------------------------------------
# The mini-bash-lib contains these functions and options ...
#
#   confirm     -a -i -n -y
#   embed       [no options]
#   error       -a -t -q
#   folder      -c -m -q
#   message     -a -i
#   symlink     -n
#   system      [no options]
#   trace       [all options ignored]
#   quit        -e -s
#
# ------------------------------------------------------------------------------

if [ -z "$CEN_NAME" ] ; then                    # have no centauri-bash-lib
    CEN_OPT_FORCE=          # option -f
    CEN_OPT_VERB=0          # option -v
    CEN_EXIT=0              # exit code
    CEN_NAME="${BASH_SOURCE##*/}"

    message() {
        [ "$1" = '-a' ] && shift
        if [ "$1" = '-i' ] ; then
            shift ; echo "${CEN_NAME//?/ }  $*"
        else
            echo "$CEN_NAME: $*" >&2
        fi
    }

    trace() {
        [ "$CEN_VERB" -lt 2 ] && return 0
        while [ "${1::1}" = '-' ] ; do shift ; done
        echo "${CEN_NAME//?/ }  $*" >&2
    }

    # simplified error message: [-q|-t] <text>...
    error() {
        case "$1" in
        -a)     shift ;;
        -q)     [ "${CEN_EXIT}" = 0 ] && return 0
                shift ; quit -e "$*" ;;
        -t)     [ "${CEN_EXIT}" = 0 ] && return 0 || return 1
        esac
        echo "$CEN_NAME: ***ERROR***" "$@" >&2
        CEN_EXIT=1 ; return 1
    }

    # yes/no confirm: [-y|-n] [-a|-i] <text>...
    confirm() {
        local oind yesn='[Y/n]' defn=0
        while [ "${1::1}" = '-' ] ; do
            case "$1" in
            --) shift ; break ;;
            -a) ;;
            -i) oind=1 ;;
            -n) yesn='[y/N]' ; defn=1 ;;
            -y) ;;
            esac ; shift
        done

        if [ -n "$oind" ] ; then
            read -p "${CEN_NAME//?/ }  $* $yesn "
        else
            read -p "$CEN_NAME: $* $yesn "
        fi
        [ "${REPLY::1}" = 'y' ] && return 0
        [ "${REPLY::1}" = 'n' ] && return 1
        return "$defn"
    }

    embed() {
        local prog="$1" ; shift
        system "$prog" --embed="$CEN_NAME" "$@"
    }

    folder() {
        local ochg omak oqui
        while [ "${1::1}" = '-' ] ; do
            case "$1" in
            --) shift ; break ;;
            -c) ochg=1 ;;
            -m) omak=1 ;;
            -q) oqui=1 ;;
            esac ; shift
        done
        if [ -d "$1" ] ; then
            [ -z "$ochg" ] && return 0
            system cd "$1" ; return
        elif [ -n "$omak" ] ; then
            system mkdir -p "$1" ; return
        fi
        [ -z "$oqui" ] && error "Not a folder:" "$1"
        return 1
    }

    symlink() {
        local nock
        while [ "${1::1}" = '-' ] ; do
            case "$1" in
            --) shift ; break ;;
            -n) nock='-f' ;;
            esac ; shift
        done
        [ "$1" -ef "$2" ] && return 0
        system ln -s $nock -- "$@"
    }

    system() {
        "$@" && return 0
        error "Running '$1' failed (status $?)"
    }

    quit() {
        case "$1" in
        '')     ;;
        -e)     shift ; error "$*" ;;
        -s)     CEN_EXIT="${2:-2}" ;;
        *)      message "$*"
        esac
        exit "$CEN_EXIT"
    }

    while [ "${1::1}" = '-' ] ; do
        case "$1" in
        -f)   CEN_OPT_FORCE=1 ; shift ;;
        -v)   CEN_VERB=2 ; shift ;;
        *)  break
        esac
    done
    run "$@"                                # using mini-bash-lib
else
    main "$@" ; quit                        # using centauri-bash-lib
fi

# end

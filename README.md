NOT YET READY, STILL UPLOADING 

The centauri-soho project simplifies debian system installation/configuration

It depends on centauri-bash-tools and centauri-bash-lib.

UNDER CONSTRUCTION - Documentation is still poor and might be misleading

This git repository contains a Centauri-Soho development environment for
Debian 'bookworm' and configuration 'worms'. The make it work you need
to install centauri-tools 1st. The recommended way to do so is:

1) Get a Virtual Machine with a minimal Debian, login as 'root'

    -> debian installer

2) Add a user 'local' and give it sudo permissions:

    adduser ...
    apt install sudo
    echo 'local   ALL=(ALL:ALL)   NOPASSWD: ALL' >/etc/sudoers.d/user-local

3) Login as 'local', install git and clone 'j-pfennig/centauri-soho':

    sudo -i
    apt install git
    git clone https://github.com/j-pfennig/centauri-soho

4) goto centauri-soho/dists/bookworm and copy:

    cp -r --preserve=mode,timestamps static/* dynamic/* /
    echo 'wheel:x:51' >/etc/group
    echo 'pulse:x:505:audio::/run:/usr/sbin/nologin' >/etc/passwd

5) goto cenrauri-soho/dists/bookworm to fix ownerships of files:

    sudo centauriowner --base=. restore OWNERS
    sudo cp -r --attributes-only static/* dynamic/* /




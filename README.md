NOT YET READY, STILL UPLOADING 

The centauri-soho project simplifies debian system installation/configuration

It depends on centauri-bash-tools and centauri-bash-lib.

UNDER CONSTRUCTION - Documentation is still poor and might be misleading

================================================================================
Installing the development environment via github.com/j-pfennig/centauri-soho
================================================================================

This git repository contains a Centauri-Soho development environment for
Debian 'bookworm' and configuration 'worms'. The make it work you need
to install centauri-tools 1st. The recommended way to do so is:

1) Get a Virtual Machine with a minimal Debian, login as 'root'

    -> debian installer

2) Add a user 'local' and give it sudo permissions:

    adduser ...
    apt install sudo
    echo 'local   ALL=(ALL:ALL)   NOPASSWD: ALL' >/etc/sudoers.d/user-local

================================================================================
For step 3-5 you may download and use this tool: sudo README.bash
================================================================================

3) Login as 'local', install git and clone 'j-pfennig/centauri-soho':

    sudo -i
    apt install git
    git clone https://github.com/j-pfennig/centauri-soho
    cd centauri-soho/dists/bookworm

4) goto centauri-soho/dists/bookworm and copy:

    echo 'wheel:x:51' >/etc/group
    echo 'pulse:x:505:505::/run:/usr/sbin/nologin' >/etc/passwd
    chown -R root:root .  
    cp -rauP static/* dynamic/* /

5) goto centauri-soho/dists/bookworm to fix ownerships of files:

    centauriowner --base=. restore OWNERS
    cp -rf --attributes-only static/* dynamic/* /

================================================================================

6) test building of a distributable tar:

    centaurisoho --base centauri-soho --current bootworm:worms dist

That's it!

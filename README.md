The centauri-soho project simplifies debian system installation/configuration

It depends on centauri-bash-tools and centauri-bash-lib.
To avoid verioning problems both are included in this
repository.

Documentation is still poor and might be misleading

--------------------------------------------------------------------------------

This setup is a proof that a master workspace can be checked out
from github. It has only limited repository support. For a real 
Production system is might be better to:

    (a) setup a client from an image tar or at least a distributable
        tar.
    (b) do the same for a server (which holds your master repository)
    (c) while the centauri-soho setup workspaces were located at /root
        the master workspace must be installed at /home/local. The
        setup workspaces should be deleted.
    (d) just unpack the workspace from a centaurisoho-master tar or
        clone from git
    (e) run 'centaurisoho owners' if cloned from git

This setup does not create a Centauri-Soho installation. If you
want to have this run 'centauricreate --info install' and then
'centauriconfig ...' and 'centaurisoho rename'. If you make it
a server do not forget the stageing area 'centaurimachines init'.

--------------------------------------------------------------------------------

Installing the development environment via github.com/j-pfennig/centauri-soho

This git repository contains a Centauri-Soho development environment for
Debian 'bookworm' and configuration 'worms'. The make it work you need
to install centauri-tools 1st. The recommended way to do so is:

1) Get a Virtual Machine with a minimal Debian, login as 'root'

    -> debian installer

2) Add a user 'local' and give it sudo permissions:

        adduser ...
        apt install sudo
        echo 'local   ALL=(ALL:ALL)   NOPASSWD: ALL' >/etc/sudoers.d/user-local

For step 3-5 you may download and use this tool: sudo README.bash
    
--------------------------------------------------------------------------------
3) Login as 'local', install git and clone 'j-pfennig/centauri-soho':

        sudo -i
        apt install git
        git clone https://github.com/j-pfennig/centauri-soho
        cd centauri-soho/dists/bookworm

4) goto centauri-soho/dists/bookworm and copy:

        echo 'wheel:x:51' >>/etc/group
        echo 'pulse:x:505:505::/run:/usr/sbin/nologin' >>/etc/passwd
        chown -R root:root .  
        cp -rauP static/* dynamic/* /

5) goto centauri-soho/dists/bookworm to fix ownerships of files:

        centauriowner --base=. restore OWNERS
        cp -rf --attributes-only static/* dynamic/* /

--------------------------------------------------------------------------------

6) test building of a distributable tar:

        centaurisoho --base centauri-soho --current bootworm:worms dist

That's it!

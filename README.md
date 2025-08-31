# POrtable DEbian ENvironment &nbsp;<a href="https://www.debian.org"><img src="https://www.debian.org/logos/officiallogo-nd.svg" style="height: 1em; vertical-align: top;"></a>

This repository contains a collection of configuration files and installation scripts for a complete and efficient minimal *UNIX* work environment based on any *Debian* or *Debian-based* distribution.

The purpose of this project is to provide a vim-loving, neckbeard-like, barebone environment, fancy enough to be used as a daily driver but not too fancy to be bloated with unnecessary software and dependencies.




## Install

The only prerequisite you need to cover is a working *Debian* in any version or form. There are three installers at your disposal to easy the setup process: [`podeen_base`](https://github.com/matteogiorgi/podeen/blob/main/podeen_base), [`podeen_plug`](https://github.com/matteogiorgi/podeen/blob/main/podeen_plug), [`podeen_code`](https://github.com/matteogiorgi/podeen/blob/main/podeen_code). Each of the installer is independent from the others and the three can be run in any order.

> The installers do not symlink any file, they just copy the configurations in the right place, so they can be easily modified end eventually resetted running the single installer again.




### Base

This script installs the basic packages and configures *Bash*, *Vim* and *Tmux* for you: just run `./podeen_base` from the root of the repository, relaunch your terminal and you are good to go.

If you are running *Bookworm*, this script adds *Trixie* repository to your sources-list; for any other running version (older, testing or unstable), it just updates and upgrades your system instead.




### Plug

This one installs additional plugins for your *Vim* alongside a little *vimscript* configuration to glue them together: run `./podeen_plug` from the root of the repository, launch *Vim* and see the magic happen.

You need to have *Vim 9.0* or higher installed for this script to work, but it won't be an issue since you should have a working *Debian 12* by now.




### Code

This last script trims a little bit of the neckbear: it resets your *VSCode* configuration and installs a couple of extensions to make it as loose as a goose and ready to roll in no time. Run `./podeen_code` from the root of the repository ;)

You need to have *VSCode* installed, check the [official website](https://code.visualstudio.com) for the deb package.

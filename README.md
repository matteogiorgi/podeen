# POrtable DEbian ENvironment

This repository contains a collection of configuration files and installation scripts for a complete and efficient minimal *UNIX* work environment based on any *Debian* or *Debian-based* distribution.

The purpose of this project is to provide a vim-loving, neckbeard-like, barebone environment, fancy enough to be used as a daily driver but not too fancy to be bloated with unnecessary software and dependencies.




## Install

The only prerequisite you need to cover is a working *Debian* in any version and in any form (from actual [Debian](https://www.debian.org) and its [derivatives](https://distrowatch.com/search.php?ostype=Linux&category=All&origin=All&basedon=Debian&notbasedon=None&desktop=All&architecture=All&package=All&rolling=All&isosize=All&netinstall=All&language=All&defaultinit=All&status=Active#simpleresults) to any Linux subsystem based on it).

You will have three installers at your disposal: [`podeen-base`](https://github.com/matteogiorgi/podeen/blob/main/podeen-base), [`podeen-plug`](https://github.com/matteogiorgi/podeen/blob/main/podeen-plug), [`podeen-code`](https://github.com/matteogiorgi/podeen/blob/main/podeen-code); each of them is independent from the others and they can be run in any order.

> The installers do not symlink any file, they just copy the configurations in the right place, so they can be easily modified end eventually resetted running the single installer again.




### `podeen-base`

This script installs the basic packages and configures *Bash* as your default `$SHELL`, *Vim* as your default `$EDITOR`, and *Tmux* as your default `$TERM`: just run `./podeen-base` from the root of the repository, relaunch your terminal and you are good to go.

> The script adds the *testing* repository to your sources list if you are running the last *stable* version of *Debian*.




### `podeen-plug`

This script installs additional plugins for your *Vim* together with a little *vimscript* configuration to glue them together: run `./podeen-plug` from the root of the repository, launch *Vim* and see the magic happen.

> You need to have *Vim 9.0* or higher installed, but it won't be an issue since you should have a working *Debian 12* by now.




### `podeen-code`

This one resets your *VSCode* configuration and installs a couple of extensions to make it the more vanilla possible: run `./podeen-code` from the root of the repository and launch your *VSCode*.

> You need to have *VSCode* installed, check the [official website](https://code.visualstudio.com).




<a href="https://www.debian.org"><img src="https://upload.wikimedia.org/wikipedia/commons/5/5c/Powered_by_Debian.svg" width="10%"></a>

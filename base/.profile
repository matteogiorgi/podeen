# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.
# See /usr/share/doc/bash/examples/startup-files for examples,
# the files are located in the bash-doc package.
# ---
# The default umask is set in /etc/profile; for setting the umask for ssh logins,
# install and configure the libpam-umask package (umask 022)




### Env-Variables (extend $PATH)
################################

export TERM='xterm-256color'
export SHELL='/usr/bin/bash'
export PAGER='/usr/bin/less'
export EDITOR='/usr/bin/vi'
export VISUAL='/usr/bin/vi'
# ---
mkdir -p "$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/bin"




### Bourn-Again Shell integration
#################################

if [ -n "$BASH_VERSION" ]; then
    [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
fi




### Keyboard remaps (x11-xkb-utils)
###################################

if [ -x "$(command -v setxkbmap)" ]; then
    setxkbmap -option "caps:escape"
fi

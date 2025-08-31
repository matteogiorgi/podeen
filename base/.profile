# ~/.profile
# ----------
# Script executed by command interpreter for login shells and not read by Bash if
# ~/.bash_profile or ~/.bash_login exists. /etc/profile hold default umask, install
# and configure libpam-umask package (umask 022), to set the umask for ssh logins.




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

# ~/.profile
# ----------
# Script executed by command interpreter for login shells and not read by Bash if
# ~/.bash_profile or ~/.bash_login exists. /etc/profile hold default umask, install
# and configure libpam-umask package (umask 022), to set the umask for ssh logins.




### Environment
###############

mkdir -p "$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/bin"
export SHELL='/usr/bin/bash'
export PAGER='/usr/bin/less'
export EDITOR='/usr/bin/vi'
export VISUAL='/usr/bin/vi'




### Session
###########

if [ -n "$DISPLAY" ] || expr "$XDG_SESSION_TYPE" : 'x11\|wayland' >/dev/null 2>&1; then
    export TERM='xterm-256color'
    if [ "$XDG_SESSION_TYPE" = "x11" ] && command -v setxkbmap >/dev/null 2>&1; then
        setxkbmap -option "caps:escape"
    fi
fi




### Bourne-Again-Shell
######################

if [ -n "$BASH_VERSION" ]; then
    [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
fi

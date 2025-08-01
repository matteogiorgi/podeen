# ~/.bashrc: executed by bash(1) for non-login shells.
# See /usr/share/doc/bash/examples/startup-files in the
# bash-doc package for examples.
# ---
# Bourne again shell - https://www.gnu.org/software/bash/




### Interactive
###############

case $- in
    *i*) ;;
    *) return;;
esac




### History & Options
#####################

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
# ---
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar




### Lesspipe & Chroot
#####################

if [[ -x /usr/bin/lesspipe ]]; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi
# ---
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi




### Functions
#############

function git-branch () {
    function git-status () {
        [[ $(\git status --porcelain 2>/dev/null) ]] && echo "*"
    }
    \git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(git-status))/"
}
# ---
function fexplore () {
    [[ -x "$(command -v fzy)" ]] || return
    TMP="/tmp/fexplore$$"
    (
        while FEXPLORE="$(\ls -aF --ignore="." --ignore=".git" --group-directories-first | `
              `\fzy -p "$(pwd | sed "s|^$HOME|~|")$(git-branch "(%s)") > ")"; do
            FEXPLORE="$PWD/${FEXPLORE%[@|*|/]}"
            if [[ -d "$FEXPLORE" ]]; then
                cd "$FEXPLORE" || return
                printf '%s\n' "$FEXPLORE" > "$TMP"
                continue
            fi
            case $(file --mime-type "$FEXPLORE" -bL) in
                text/* | application/json) "${EDITOR:=/usr/bin/vi}" "$FEXPLORE";;
                *) xdg-open "$FEXPLORE" &>/dev/null;;
            esac
        done
    )
    [[ -f "$TMP" ]] || return
    cd "$(\cat $TMP)" || return
    rm -f "$TMP"
}
# ---
function ffind () {
    [[ -x "$(command -v fzy)" ]] || return
    [[ -x "$(command -v fdfind)" ]] && FFIND="$(\fdfind . --type file)" || \
          FFIND="$(\find . -type f -not -path '*/\.*' -not -path '.')"
    FFIND="$(echo "$FFIND" | sed 's|^\./||' | \
          \fzy -p "$(pwd | sed "s|^$HOME|~|")$(git-branch "(%s)") > ")"
    [[ -f "$FFIND" ]] || return
    case $(file --mime-type "$FFIND" -bL) in
        text/* | application/json) "${EDITOR:=/usr/bin/vi}" "$FFIND";;
        *) xdg-open "$FFIND" &>/dev/null;;
    esac
}
# ---
function fjump () {
    [[ -x "$(command -v fzy)" ]] || return
    [[ -x "$(command -v fdfind)" ]] && FJUMP="$(\fdfind . --type directory)" || \
          FJUMP="$(find . -type d -not -path '*/\.*' -not -path '.')"
    TMP="/tmp/fjump$$"
    (
        FJUMP="$(echo "$FJUMP" | sed 's|^\./||' | \
              \fzy -p "$(pwd | sed "s|^$HOME|~|")$(git-branch "(%s)") > ")"
        [[ -d "$FJUMP" ]] && printf '%s\n' "$FJUMP" > "$TMP"
    )
    [[ -f "$TMP" ]] || return
    cd "$(cat $TMP)" || return
    rm -f "$TMP"
}
# ---
function fhook () {
    [[ -x "$(command -v tmux)" && -x "$(command -v fzy)" ]] || return
    [[ -z "$TMUX" ]] || { \tmux display-message -p 'attached to #S'; return; }
    BASENAME="$(basename "$PWD" | cut -c 1-37)"
    SESSIONS="$(\tmux list-sessions -F '#{session_name}' 2>/dev/null)"
    SCOUNTER="$(\tmux list-sessions 2>/dev/null | wc -l)"
    if \tmux has-session -t "$BASENAME" 2>/dev/null; then
        if FHOOK="$(echo "$SESSIONS" | \fzy -p "tmux-sessions ($SCOUNTER) > ")"; then
            \tmux attach -t "$FHOOK"
        fi
    elif FHOOK="$( (echo "$BASENAME (new)"; echo "$SESSIONS") | \fzy -p "tmux-sessions ($SCOUNTER) > " )"; then
        [[ "$FHOOK" == "$BASENAME (new)"  ]] && { \tmux new-session -c "$PWD" -s "$BASENAME"; return; }
        \tmux attach -t "$FHOOK"
    fi
}
# ---
function fgit() {
    [[ -x "$(command -v git)" && -x "$(command -v fzy)" ]] || return
    [[ $(\git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]] || { echo "'$PWD' is not a git repo"; return; }
    if FGIT="$(\git log --graph --format="%h%d %s %cr" "$@" | `
          `\fzy -p "$(pwd | sed "s|^$HOME|~|")$(git-branch "(%s)") > ")"; then
        FGIT="$(echo "$FGIT" | grep -o '[a-f0-9]\{7\}')"
        \git diff "$FGIT"
    fi
}
# ---
function fbase() {
    [[ -x "$(command -v git)" ]] || return
    [[ $(\git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]] || { echo "'$PWD' is not a git repo"; return; }
    [[ $(\git rev-parse --show-toplevel 2>/dev/null) != "$PWD" ]] || { echo "'$PWD' is already toplevel"; return; }
    cd "$(\git rev-parse --show-toplevel 2>/dev/null)" || return
}
# ---
function fkill() {
    [[ -x "$(command -v fzy)" ]] || return
    if FKILL="$(ps --no-headers -H -u "$USER" -o pid,cmd | \fzy -p "$USER processes > ")"; then
        PROCPID="$(echo "$FKILL" | awk '{print $1}')"
        PROCCMD="$(echo "$FKILL" | awk '{$1=""; sub(/^ /, ""); print}')"
        if FKILLSIGNAL="$(printf " 0 SIGNULL\n 1 SIGHUP\n 2 SIGINT\n 3 SIGQUIT\n 4 SIGILL\n 5 SIGTRAP\n 6 SIGABRT\n 7 SIGBUS\n`
              ` 8 SIGFPE\n 9 SIGKILL\n10 SIGUSR1\n11 SIGSEGV\n12 SIGUSR2\n13 SIGPIPE\n14 SIGALRM\n15 SIGTERM\n`
              `16 SIGSTKFLT\n17 SIGCHLD\n18 SIGCONT\n19 SIGSTOP\n20 SIGTSTP\n21 SIGTTIN\n22 SIGTTOU\n23 SIGURG\n`
              `24 SIGXCPU\n25 SIGXFSZ\n26 SIGVTALRM\n27 SIGPROF\n28 SIGWINCH\n29 SIGIO\n30 SIGPWR\n31 SIGSYS\n" | `
              `\fzy -p "process \"${PROCCMD:0:50}\" selected > ")"; then
            if [[ "${FKILLSIGNAL:0:2}" == " 0" ]]; then
                echo "process \"${PROCCMD:0:50}\" intact"
                return
            fi
            kill -s "${FKILLSIGNAL:0:2}" "$PROCPID"
            echo "process \"${PROCCMD:0:50}\" signaled with ${FKILLSIGNAL:3}"
        fi
    fi
}




### Aliases
###########

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" \
"$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# ---
alias lf='ls -CF'
alias la='ls -A'
alias ll='ls -alFtr'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias xcopy="xclip -in -selection clipboard"
alias xpasta="xclip -out -selection clipboard"
alias xcopyfile='xclip-copyfile'
alias xpastafile='xclip-pastefile'
alias xcutfile='xclip-cutfile'




### PS1 (with color support)
############################

if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;90m\]\t\[\033[00m\] \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;94m\]\w\[\033[00m\]'
    PS1+='\[\033[01;33m\]$(git-branch "(%s)")\[\033[00m\]\n '
else
    PS1='${debian_chroot:+($debian_chroot)}\t \u@\h:\w'
    PS1+='$(git-branch "(%s)")\n '
fi




### Completion
##############

if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi
fi




### Color-support
#################

export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;37m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# ---
if [[ -x /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi




## Mode & Binds (no ~/.inputrc)
###############################

set -o vi
bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string ">"'
bind 'set vi-cmd-mode-string "$"'
# ---
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'
# ---
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'
bind 'set completion-ignore-case on'
bind 'set completion-prefix-display-length 3'
bind 'set mark-symlinked-directories on'
bind 'set visible-stats on'
bind 'set colored-stats on'
# ---
bind -m vi-command -x '"\C-l": clear -x && echo ${PS1@P}'
bind -m vi-command -x '"\C-e": fexplore && echo ${PS1@P}'
bind -m vi-command -x '"\C-b": fbase && echo ${PS1@P}'
bind -m vi-command -x '"\C-j": fjump && echo ${PS1@P}'
bind -m vi-command -x '"\C-k": fhook'
bind -m vi-command -x '"\C-f": ffind'
bind -m vi-command -x '"\C-g": fgit'
bind -m vi-command -x '"\C-x": fkill'
bind -m vi-insert -x '"\C-l": clear -x && echo ${PS1@P}'
bind -m vi-insert -x '"\C-e": fexplore && echo ${PS1@P}'
bind -m vi-insert -x '"\C-b": fbase && echo ${PS1@P}'
bind -m vi-insert -x '"\C-j": fjump && echo ${PS1@P}'
bind -m vi-insert -x '"\C-k": fhook'
bind -m vi-insert -x '"\C-f": ffind'
bind -m vi-insert -x '"\C-g": fgit'
bind -m vi-insert -x '"\C-x": fkill'




### System-fetcher
##################

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    mkdir -p "$HOME/.local/bin"
    export PATH="$PATH:$HOME/.local/bin"
fi
# ---
if [[ -x "$(command -v fetch.sh)" ]]; then
    fetch.sh 2>/dev/null
fi

#!/usr/bin/env bash

# This base setup script will install a minimal work environment,
# complete with all the bells and whistles needed to start working properly.
# ---
# There are no worries of losing a potential old configuration: il will be
# stored in a separate folder in order to be restored manually if needed.
# ---
# Other applications not included here (this is a minimal setup) can be
# installed manually through the apt package manager. Mind the following:
# distrobox input-remapper dconf-editor gnome-shell-extension-manager




### Check & Funcs
#################

RED='\033[1;36m'
NC='\033[0m'
# ---
if [[ -d "${HOME}/.podeen-recovery" ]]; then
    printf "\n${RED}%s${NC}"   "════════════════ Warning: podeen already set ════════════════"
    printf "\n${RED}%s${NC}\n" "Remove ~/.podeen-recovery directory and run this script again"
    exit 1
fi
# ---
function warning-message () {
    if [[ "$(id -u)" = 0 ]]; then
        printf "\n${RED}%s${NC}"     "This script MUST NOT be run as root user since it makes changes"
        printf "\n${RED}%s${NC}"     "to the \$HOME directory of the \$USER executing this script."
        printf "\n${RED}%s${NC}"     "The \$HOME directory of the root user is, of course, '/root'."
        printf "\n${RED}%s${NC}"     "We don't want to mess around in there. So run this script as a"
        printf "\n${RED}%s${NC}\n\n" "normal user. You will be asked for a sudo password when necessary."
        exit 1
    fi
}
# ---
function error-echo () {
    printf "${RED}ERROR: %s${NC}\n" "$1" >&2
    exit 1
}
# ---
function store-conf () {
    function backup-conf () {
        if [[ -f "$1" ]]; then
            if [[ -L "$1" ]]; then
                command unlink "$1"
            else
                mv "$1" "${RESTORE}/"
            fi
        fi
    }
    RESTORE="${HOME}/.podeen-recovery" && command mkdir -p "${RESTORE}"
    backup-conf "${HOME}/.bash_logout"
    backup-conf "${HOME}/.bashrc"
    backup-conf "${HOME}/.profile"
    backup-conf "${HOME}/.tmux.conf"
    backup-conf "${HOME}/.vimrc"
    backup-conf "${HOME}/.local/bin/fetch.sh"
}




### Start
#########

warning-message
SCRIPTPATH="$( cd "$(command dirname "$0")" ; pwd -P )" || exit 1
"${SCRIPTPATH}/unix/fetch.sh"
command sudo apt-get update && sudo apt-get upgrade -qq -y || error-echo "syncing repos"
command sudo apt-get install -qq -y bash bash-completion fzy file fd-find xclip trash-cli \
      git tmux vim python3 wamerican htop || error-echo "installing from apt"
# ---
store-conf
cp "${SCRIPTPATH}/unix/.bash_logout" "${HOME}/"
cp "${SCRIPTPATH}/unix/.bashrc" "${HOME}/"
cp "${SCRIPTPATH}/unix/.profile" "${HOME}/"
cp "${SCRIPTPATH}/unix/.tmux.conf" "${HOME}/"
cp "${SCRIPTPATH}/unix/.vimrc" "${HOME}/"
# ---
command mkdir -p "${HOME}/.local/bin/"
cp "${SCRIPTPATH}/unix/fetch.sh" "${HOME}/.local/bin/"




### Finish
##########

printf "\n${RED}%s${NC}\n" "setup complete"

#!/usr/bin/env bash

# VSCode reset with just few tweaks and GitHub-Copilot extension:
# https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
# https://marketplace.visualstudio.com/items?itemName=ms-python.python
# https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter
# https://marketplace.visualstudio.com/items?itemName=golang.Go
# ---
# VSCode is not included in the Debian repos,
# install it separately: https://code.visualstudio.com/.




### Check & Funcs
#################

RED='\033[1;36m'
NC='\033[0m'
# ---
if [[ ! -x "$(command -v "code")" ]]; then
    printf "\n${RED}%s${NC}"   "═══════ Warning: VSCode not found ══════"
    printf "\n${RED}%s${NC}\n" "Install VSCode and run this script again"
    exit 1
fi
# ---
function error-echo () {
    printf "${RED}ERROR: %s${NC}\n" "$1" >&2
    exit 1
}




### Path & Dependencies
#######################

SCRIPTPATH="$( cd "$(command dirname "$0")" ; pwd -P )" || exit 1
command sudo apt-get update && sudo apt-get upgrade -qq -y || error-echo "syncing repos"
command sudo apt-get install -qq -y gnome-keyring git bash dash golang-go gopls python3 \
      python3-pip black jupyter fonts-firacode || error-echo "installing from apt"




### Start
#########

BASE="${HOME}/.config/Code/User" && command mkdir -p "${BASE}"
for EXTENSION in $(command code --list-extensions); do
    command code --uninstall-extension "${EXTENSION}" &>/dev/null
done
# ---
command code --install-extension github.copilot &>/dev/null
command code --install-extension golang.go &>/dev/null
command code --install-extension ms-python.python &>/dev/null
command code --install-extension ms-python.black-formatter &>/dev/null
command code --install-extension ms-toolsai.jupyter &>/dev/null
cat "${SCRIPTPATH}/code/settings.json" > "${BASE}/settings.json"
cat "${SCRIPTPATH}/code/keybindings.json" > "${BASE}/keybindings.json"




### Finish
##########

printf "\n${RED}%s${NC}\n" "setup complete"

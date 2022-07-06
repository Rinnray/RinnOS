#!/usr/bin/env bash

echo "##################"
echo "## FINAL SETUPS ##"
echo "##################"
echo

DOTDIR=$HOME/RinnOS/dotfiles
# DOTFILES=(
#     # --- Home ---
#     '.zshrc'
#     '.gitconfig'
#     '.emacs.d'
#     '.doom.d'
#     'wallpapers'
#     'scripts'

#     # --- .config ---
#     '.config/i3'
#     '.config/pulsemeeter'
#     '.config/flameshot'
# )

LOCALDOTDIR=/mnt/Vault/Dotfiles/Linux/Arch
# LOCALDOTFILES=(
#     # --- Home ---
#     '.ssh'
#     '.waterfox'
#     '.vscode'

#     # --- .config ---
#     '.config/BetterDiscord'
#     '.config/Code'
#     '.config/discord'
#     '.config/discordcanary'
#     '.config/FreeTube'
#     '.config/Logseq'
#     '.config/lutris'
#     '.config/Rambox'
#     '.config/rambox'
#     '.config/wtwitch'

#     # --- .local ---
#     '.local/share/lutris'
#     '.local/share/Steam'
#     '.local/share/vulkan'
#     '.local/share/PolyMC'
#     '.local/share/7DaysToDie'
# )

echo "-----------------------"
echo "-- Starting Services --"
echo "-----------------------"
echo

sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

echo "---------------"
echo "-- ZSH Setup --"
echo "---------------"
echo

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "---------------------------"
echo "-- Dealing with dotfiles --"
echo "---------------------------"
echo

I=0
while [ $I -le $(yq '.git | length' dotfiles.yaml) ]; do
    dotfile=$(yq .git[$I] dotfiles.yaml)

    rm -rf "${HOME}/$dotfile"
    echo
    echo "Linking ${DOTDIR}/${dotfile} to ${HOME}/${dotfile}"
    cp -faTs "${DOTDIR}/${dotfile}" "${HOME}/${dotfile}"
    ((I++))
done

# for dotfile in "${DOTFILES[@]}"; do
#     rm -rf "${HOME}/$dotfile"
#     echo
#     echo "Linking ${DOTDIR}/${dotfile} to ${HOME}/${dotfile}"
#     cp -faTs "${DOTDIR}/${dotfile}" "${HOME}/${dotfile}"
# done

I=0
while [ $I -le $(yq '.local | length' dotfiles.yaml) ]; do
    localdotfile=$(yq .local[$I] dotfiles.yaml)

    rm -rf "${HOME}/${localdotfile}"
    echo
    echo "Linking ${LOCALDOTDIR}/${localdotfile} to ${HOME}/${localdotfile}"
    cp -faTs "${LOCALDOTDIR}/${localdotfile}" "${HOME}/${localdotfile}"
    ((I++))
done

# for localdotfile in "${LOCALDOTFILES[@]}"; do
#     rm -rf "${HOME}/${localdotfile}"
#     echo
#     echo "Linking ${LOCALDOTDIR}/${localdotfile} to ${HOME}/${localdotfile}"
#     cp -faTs "${LOCALDOTDIR}/${localdotfile}" "${HOME}/${localdotfile}"
# done

echo "-------------------------"
echo "-- Some extra stuff... --"
echo "-------------------------"
echo

echo "Setting RTC to local time"
sudo timedatectl set-local-rtc 1

echo
echo "Changing default shell to zsh"
chsh -s $(which zsh)

echo
echo "Syncing Doom emacs"
cd $HOME/.emacs.d/bin
sh doom sync

echo "###########"
echo "## DONE! ##"
echo "###########"
echo

echo "Do you want to reboot? (y/n)"
read reboot
if [ "$reboot" == "y" ]; then
    echo "Rebooting..."
    sudo reboot
fi
#!/usr/bin/env bash

loopScript=true

while $loopScript; do
    clear
    
    echo "What would you like to do?"
    echo "1. Install base packages"
    echo "2. Install software packages"
    echo "3. Install AUR packages"
    echo "4. Install AppImages"
    echo "5. Run post-installation script"
    echo "6. Exit"
    echo
    read -p "Enter your choice: " choice

    # If they chose to install base packages, run the base-packages.sh script.
    if [ $choice -eq 1 ]; then
        sh 1-base.sh || exit 1
    fi

    # If they chose to install software packages, run the software-packages.sh script.
    if [ $choice -eq 2 ]; then
        sh 2-software-pacman.sh || exit 1
    fi

    # If they chose to install AUR packages, run the aur-packages.sh script.
    if [ $choice -eq 3 ]; then
        sh 3-software-aur.sh || exit 1
    fi

    # If they chose to install AppImages, run the appimage-packages.sh script.
    if [ $choice -eq 4 ]; then
        sh 4-software-appimage.sh || exit 1
    fi

    # If they chose to run the post-installation script, run the post-setup.sh script.
    if [ $choice -eq 5 ]; then
        sh 9-post-setup.sh || exit 1
    fi

    # If they chose to exit, exit the loop.
    if [ $choice -eq 6 ]; then
        loopScript=false
    fi
done
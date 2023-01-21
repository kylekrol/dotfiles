
# Installation Guide

This file is intended to serve as a loose installation guide outline how to
download/setup with the version controlled dotfiles and an overview some package
installtions.

This is by no means a complete guide and assumes the pacman package manager.

## Dotfiles

To use the dotfiles on a new machine, simply make a `~/.dotfiles` directory,
clone the repository into the new folder, and alias the `dotfiles` command
as shown below.

    cd
    mkdir .dotfiles
    git clone git@github.com:kylekrol/dotfiles.git .dotfiles
    alias dotfiles='git --git-dir="$HOME"/.dotfiles --work-tree="$HOME"'

From there, update the git configuration to ignore untracked files by default
and checkout the default branch into the home folder.

    dotfiles config --local status.showUntrackedFiles no
    dotfiles checkout

It's recommended to change the user shell to zsh and logout to update aliases,
environment variables, et cetera. Pay special attention to dotfiles as well; the
many environment variables are tweaked in `~/.xprofile` to clear out the home
folder.

## Packages

Note this is not a complete list of packages and assumes a base system including
graphics drivers has already been installed. The packages outlined below are
generally installed across all of my systems and are commonly dependencies for
scripts and such in the dotfiles.

### AUR Helper

If so desired an AUR helper can be installed. Below I'm just cloning the AUR
helper package into the directory the AUR helper will look for it in the future
to prevent having two copies sitting around my system.

    mkdir -p ~/.local/share/pikaur/aur_repos
    cd ~/.local/share/pikaur/aur_repos
    git clone https://aur.archlinux.org/pikaur.git
    cd pikaur
    makepkg -sirc

### Bluetooth, Networking, and Audio

Install bluetooth support, wifi support, a simple firewall, a Network Time
Protocol client daemon, and an audio server.

    sudo pacman -S                                      \
        bluez bluez-utils                               \
        networkmanager                                  \
        nftables                                        \
        ntp                                             \
        pulseaudio pulseaudio-alsa pulseaudio-bluetooth

After installing, be sure to enable (and start if you'd like) the respective
systemd services.

    sudo systemctl enable bluetooth.service
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable nftables.service

### Display Server

Install the Xorg display server, it's associatted configuration utilities, and
Google fonts.

    sudo pacman -S                                                  \
        xorg-apps xorg-server                                       \
        noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

### Display Manager

Install the lightdm display manager, a couple greeters, and some backgrounds.

    sudo pacman -S                                        \
        lightdm lightdm-gtk-greeter lightdm-slick-greeter \
        plasma-workspace-wallpapers

Enable the display manager when desired.

    sudo systemctl enable lightdm.service

There's gui front-end to edit the slick greeter configuration as well.

    pikaur -S lightdm-settings

### Desktop Environment

I personally use bspwm as my window manager alongside many of background
utilities, panels, et cetera from xfce.

    sudo pacman -S                                                            \
        bspwm picom sxhkd                                                     \
        xfce4-notifyd xfce4-panel xfce4-power-manager xfce4-pulseaudio-plugin \
        xfce4-settings                                                        \
        alacritty blueman light-locker network-manager-applet                 \
        nm-connection-editor polkit-gnome

In addition to the above, here are a core set of frequently used programs.

    sudo pacman -S                                                     \
        alacritty                                                      \
        thunar thunar-volman                                           \
        pavucontrol                                                    \
        zathura zathura-djvu zathura-pdf-poppler zathura-ps zathura-cb

    pikaur -S google-chrome spotify

### Software Development

An incomplete list of languages - installing language servers where
possible for lsp support in neovim.

    # C/C++
    sudo pacman -S clang lldb llvm openmp gcc gdb valgrind

    # Go
    sudo pacman -S go

    # Javascript
    sudo pacman -S nodejs npm

    # LaTeX
    sudo pacman -S                                                      \
        texlive-core texlive-bin texlive-latexextra texlive-bibtexextra \
        texlive-fontsextra

    # Lua
    sudo pacman -S lua luajit lua-language-servier lua-rocks

    # Python
    sudo pacman -S python python-setuptools tk

    # Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

Installing neovim itself with dependencies that'll be asked for by neovim - also
run `:checkhealth` in neovim to see if any other dependencies may be needed.

    sudo pacman -S neovim python-neovim ripgrep fd


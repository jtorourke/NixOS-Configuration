#!/bin/bash

# Add essential repositories
#sudo zypper ar -f https://download.opensuse.org/repositories/home:/ungoogled_chromium/openSUSE_Tumbleweed/ ungoogled-chromium
sudo zypper ar -f https://download.opensuse.org/repositories/hardware/openSUSE_Tumbleweed/ hardware
sudo zypper addrepo https://download.opensuse.org/repositories/openSUSE:Factory/standard/openSUSE:Factory.repo
sudo zypper ar -f https://download.opensuse.org/repositories/X11:/Wayland/openSUSE_Tumbleweed/ X11:Wayland
sudo zypper refresh

# Base system packages
sudo zypper install -y \
  git curl wget neofetch htop ripgrep fd-find \
  zsh kitty \
  gcc-c++ clang cmake make rust cargo \
  python311 python311-pip python311-jupyterlab \
  R-base julia \
  texlive-scheme-full \
  flatpak \
  vulkan-tools nvtop \
  udisks2 gvfs \
  pipewire pipewire-pulseaudio wireplumber \
  blueman bluez

# GUI/Wayland environment
sudo zypper install -y \
  hyprland waybar rofi swaylock swayidle sway-contrib \
  hyprpicker hyprpaper hypridle \
  wl-clipboard grim slurp eww \
  qt5-qtwayland qt6-qtwayland \
  xdg-desktop-portal xdg-desktop-portal-hyprland \
  gnome-keyring libsecret \
  wofi

# Development tools
sudo zypper install -y \
  neovim emacs lazygit \
  jetbrains-mono-fonts noto-fonts-emoji \
  docker \
  postgresql17-server postgresql17-contrib postgresql17

# Multimedia
sudo zypper install -y \
  ffmpeg-5 mpv vlc \
  obs-studio gimp inkscape \
  pavucontrol helvum

# Python packages (via pip)
pip install --user \
  pandas numpy scipy matplotlib scikit-learn ipykernel \
  jupyterlab requests beautifulsoup4

# R packages (via CRAN)
sudo R -e 'install.packages(c("tidyverse", "ggplot2", "dplyr", "shiny", "caret", "plotly", "e1071", "knitr", "xgboost", "randomForest", "remotes"), repos="https://cloud.r-project.org")'

# Additional repos needed for some packages:
# 1. For newer NVIDIA drivers (if needed):
#    sudo zypper ar -f https://download.nvidia.com/opensuse/tumbleweed nvidia
# 2. For gaming/Steam:
#    sudo zypper ar -f https://download.opensuse.org/repositories/games/openSUSE_Tumbleweed/ games

# Fonts
sudo zypper install -y \
  iosevka-fonts nerd-iosevka-fonts google-noto-fonts \
  fontawesome-fonts fira-code-fonts

# Post-install steps
sudo usermod -s /usr/bin/zsh $USER
systemctl --user enable pipewire wireplumber
sudo systemctl enable bluetooth

echo "Installation complete! Some notes:"
echo "1. Hyprland configuration needs manual migration from ~/.config/hypr"
echo "2. Nix-specific packages (like home-manager) need alternative setups"
echo "3. Check proprietary drivers with 'sudo zypper install nvidia-video-G06'"
echo "4. For Steam: sudo zypper install steam"

echo "Beginning installation of git-based packages"
cargo install spotify_player --no-default-features --features pulseaudio-backend

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install

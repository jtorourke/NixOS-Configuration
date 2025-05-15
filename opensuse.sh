#!/bin/bash

# Update system and install prerequisites
sudo pacman -Syu --noconfirm

# Install paru if not present
if ! command -v paru &> /dev/null; then
    sudo pacman -S --needed base-devel git --noconfirm
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
    rm -rf paru
fi

# Install official repository packages
sudo pacman -S --noconfirm \
    wget \
    curl \
    xorg-xrandr \
    os-prober \
    neofetch \
    screenfetch \
    fastfetch \
    kitty \
    pandoc \
    zsh \
    git \
    ripgrep \
    fd \
    htop \
    mpv \
    audacious \
    wf-recorder \
    ntfs-3g \
    exfatprogs \
    bitwarden \
    obs-studio \
    nautilus \
    ispell \
    flatpak \
    udisks2 \
    udiskie \
    gvfs \
    rustc \
    cargo \
    clang \
    stack \
    ghc \
    r \
    cmake \
    make \
    haskell-language-server \
    php \
    graphviz \
    shellcheck \
    zig \
    texlive-most \
    texlive-lang \
    font-manager \
    ttf-font-awesome \
    ttf-iosevka \
    ttf-iosevka-term \
    libnotify \
    hyprland \
    hyprlock \
    hyprpaper \
    hyprpicker \
    waybar \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-hyprland \
    xwayland \
    meson \
    wayland-protocols \
    wayland-utils \
    wl-clipboard \
    pavucontrol \
    blueman \
    bluez \
    bluez-tools \
    blueberry \
    btrfs-progs \
    emacs \
    vim \
    neovim \
    greetd

# Install AUR packages
paru -S --noconfirm \
    greetd-tuigreet \
    greetd-wlgreet \
    lazygit \
    grimblast-git \
    qview \
    wl-clip-persist-git \
    grub-theme-vimix \
    simplebluez \
    udevil \
    spotify-player \
    pom-cli \
    qmk \
    vial-git \
    morgen \
    protonmail-bridge \
    marktext \
    vesktop \
    obs-studio-wlrobs \
    git-credential-oauth \
    davinci-resolve \
    ttf-iosevka-lyte-nerd-font \
    hypridle-git \
    rofi-lbonn-wayland-git \
    rofi-power-menu \
    rofi-rbw \
    wofi-hg \
    swww \
    emptty \
    eww \
    gruvbox-gtk-theme \
    gruvbox-plus-icons \
    capitaine-cursors \
    nerd-fonts-complete 

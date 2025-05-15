#!/bin/sh
set -euo pipefail

# Check for required dependencies
check_dependency() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Error: Required command '$1' not found in PATH"
        exit 1
    fi
}

echo "Checking dependencies..."
check_dependency git
check_dependency emacs
check_dependency rg   # ripgrep
check_dependency fd   # fd-find

# Clean existing configurations
echo "Removing any existing Emacs configurations..."
rm -rf \
    "$HOME/.emacs.d" \
    "$HOME/.doom.d" \
    "$HOME/.config/emacs" \
    "$HOME/.config/doom"

# Clone Doom Emacs
echo "Cloning Doom Emacs repository..."
git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.emacs.d"

# Clone personal configuration to XDG location
echo "Cloning personal Doom configuration..."
git clone https://github.com/jtorourke/Doom_Emacs "$HOME/.config/doom"

# Install Doom with personal configuration
echo "Installing Doom Emacs with custom config..."
"$HOME/.emacs.d/bin/doom" install

# Final message
echo "Doom Emacs installation complete with personal configuration!"
echo "Add ~/.emacs.d/bin to your PATH or run:"
echo "  ~/.emacs.d/bin/doom sync"

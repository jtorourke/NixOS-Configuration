# doom.nix
{ pkgs ? import <nixpkgs> {} }:

let
  requiredPackages = with pkgs; [
    git
    emacs
    ripgrep
    fd
  ];
in
pkgs.stdenv.mkDerivation {
  name = "doom-emacs-installer";
  nativeBuildInputs = [ pkgs.makeWrapper ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin

    # Create the installation script
    cat > $out/bin/doom-install <<'EOF'
    #!/bin/sh
    set -euo pipefail

    # Clean existing configurations
    echo "Removing any existing Emacs configurations..."
    rm -rf "$HOME/.emacs.d" "$HOME/.doom.d" "$HOME/.config/emacs" "$HOME/.config/doom"

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
    EOF

    # Make script executable
    chmod +x $out/bin/doom-install

    # Wrap script to ensure dependencies are available
    wrapProgram $out/bin/doom-install \
      --prefix PATH : "${pkgs.lib.makeBinPath requiredPackages}"
  '';
}

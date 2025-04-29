{ config, pkgs, ... }:

let
  doom-emacs = pkgs.callPackage (import (builtins.fetchTarball {
    url = "https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz";
    sha256 = "0cykflc1xbar21lx253cnxvx024zbvlsyinrnarclsyl3vpx259h";
  })) {
    doomPrivateDir = ./doom-config;  # Path to your Doom config
  };
in
{
  environment.systemPackages = with pkgs; [
    # Add required dependencies
    git
    ripgrep
    fd
    clang
    (ripgrep.override { withPCRE2 = true; })
  ];

  services.emacs = {
    enable = true;
    package = doom-emacs;
  };

  # Add emacs-overlay
  nixpkgs.overlays = [
    (import (builtins.fetchTarball "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))
  ];
}

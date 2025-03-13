# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  pythonPkgs = with pkgs.python311Packages; [
    pandas
    numpy
    scipy
    matplotlib
    scikit-learn
    ipykernel
    ipython-genutils
    ipython
    jupyterlab-widgets
    jupyterlab-server
    jupyterlab
    jupyter-core
    jupyter
    calysto
    nbformat
    #conda
    requests
    beautifulsoup4
  ];

  haskellPkgs = with pkgs.haskellPackages; [
    #ihaskell_0_11_0_0
    #ipynb
    #jupyter
    #mltool
    #Frames
  ];

  rPkgs = with pkgs.rPackages; [
    tidyverse
    ggplot2
    dplyr
    shiny
    IRkernel
    tidyr
    caret
    tidyquant
    plotly
    e1071
    knitr
    XML
    xgboost
    randomForest
    tidytable
    remotes
  ];

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  #nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];
  boot.loader = {
    timeout = 60;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      #splashImage = "/home/john/Pictures/gruvbox-wallpapers/wallpapers/minimalistic/gruvbox-rainbow-nix.png";
      font = "${pkgs.iosevka}/share/fonts/truetype/Iosevka-Regular.ttf";
      theme = pkgs.stdenv.mkDerivation {
         pname = "distro-grub-themes";
         version = "3.1";
         src = pkgs.fetchFromGitHub {
          owner = "AdisonCavani";
          repo = "distro-grub-themes";
          rev = "v3.1";
          hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
        };
        installPhase = "cp -r customize/nixos $out";
      };
      extraConfig = ''
        GRUB_TIMEOUT=60
      '';
      #extraEntries = ''
       # menuentry "Windows" {
        #  insmod part_gpt
         # insmod fat
          #insmod search_fs_uuid
          #insmod chain
         # search --fs-uuid --set=root $FS_UUID
          #chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        #}
      #'';
    };

    #systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      #efiSysMountPoint = "/boot/efi";
    };
  };

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  programs.appimage.binfmt = true;
  
  systemd.user.services.home-manager-auto = {
    enable = true;
    # after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    description = "auto home-manager startup";
    serviceConfig = {
      ExecStart = ''home-manager switch'';
    };
  };
  
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-32.3.3"
  ];

  programs = {
    zsh = {
      enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

  users.defaultUserShell = pkgs.zsh;

  home-manager = {
    useUserPackages = true;
    users = {
        john = {
          home.stateVersion = "24.11";
        # Specify the home-manager configuration file location
          imports = [
            /home/john/.config/home-manager/home.nix
            #<catppuccin/modules/home-manager>
          ];
      };
    };
  };

  services.hypridle.enable = true;

  #catppuccin.enable = true;
  #catppuccin.flavor = "mocha";

  networking.hostName = "Lambda"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fileSystems."/home/john/bckp" = {
    #device = "dev/disk/by-uuid/C07CC5D17CC5C280";
    device = "dev/sda1";
    fsType = "ntfs";
    options = [
        "users"
        "nofail"
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

 # Enable the Budgie Desktop environment.
 # services.xserver.displayManager = {
 #   lightdm = {
 #     enable = false;
 #     #greeters.slick.enable = true;
 #     #greeters.slick.theme.name = "Gruvbox-Dark";
 #     #greeters.slick.iconTheme.name = "Gruvbox-Plus-Dark";
 #     #background = "/home/john/Pictures/gruvbox-wallpapers/wallpapers/minimalistic/gruvbox-rainbow-nix.png";
 #   };
 #   gdm.enable = true;
 #   #defaultSession = "budgie-desktop";
 # };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  #services.xserver.desktopManager.budgie.enable = false;

  # Hyprland configuration
  programs.hyprland = {
    xwayland = {
      enable = true;
    };
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    #WLR_NO_HARDWARE_CURSORS = "1";
  };


  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Hardware config for Nvidia
  hardware.opengl = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.john = {
    isNormalUser = true;
    description = "John";
    extraGroups = [ "networkmanager" "wheel" "storage" ];
    packages = with pkgs; [
    emacs
    vim
    neovim
    #qtile
    julia
    ranger
    nnn
    neofetch
    screenfetch
    fastfetch
    alacritty
    python3
    zsh
    starship
    #rstudio
    rustc
    git
    cargo
    spotify
    discord
    qmk
    vial
    iosevka
    nerdfonts
    font-awesome
    morgen
    protonmail-bridge
    home-manager
    ];
  };

  # Install firefox.
  #programs.firefox.enable = true;
  services.emacs.package = pkgs.emacs-unstable;
  services.flatpak.enable = true;
  services.udisks2.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # System Packages
    wget
    curl
    xorg.xrandr
    os-prober
    ranger
    nnn
    neofetch
    screenfetch
    fastfetch
    alacritty
    kitty
    pandoc
    zsh
    starship
    git
    home-manager
    ripgrep
    coreutils
    fd
    htop
    greetd.tuigreet
    greetd.wlgreet
    lazygit
    fm
    grimblast
    qview
    mpv
    audacious
    wf-recorder
    wl-clip-persist
    sleek-grub-theme
    #spacevim
    appimage-run
    #zmkBATx
    simpleBluez
    #qt6

    # Misc. Programs
    spotify
    discord
    qmk
    vial
    morgen
    protonmail-bridge
    marktext
    bitwarden-desktop
    vesktop
    obs-studio
    obs-studio-plugins.wlrobs
    #brave
    #floorp
    #vivaldi
    #vivaldi-ffmpeg-codecs
    starship
    nautilus
    git-credential-oauth
    ispell
    flatpak
    udisks
    udiskie

    # Languages / Compilers / Package Managers
    rustc
    cargo
    julia
    clang
    stack
    ghc
    R
    python3

    # Fonts
    font-manager
    nerdfonts
    font-awesome
    iosevka

    # Theming
    gruvbox-gtk-theme
    gruvbox-plus-icons
    capitaine-cursors-themed
    catppuccin

    # Window Manager
    eww
    hyprland
    hyprlock
    hyprpaper
    hyprpicker
    hypridle
    waybar
    rofi-wayland
    rofi-power-menu
    rofi-rbw-wayland
    swww # for wallpapers
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xwayland
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    ly
    emptty
    pavucontrol
    blueman
    bluez
    bluez-tools
    blueberry

    # File System support
    ntfs3g
    btrfs-progs

    # Editors
    emacs
    vim
    neovim
    #rstudio
    #jetbrains.dataspell
  ] ++ pythonPkgs ++ rPkgs ++ haskellPkgs;

  fonts.fonts = with pkgs; [
    iosevka
    nerdfonts
    font-awesome
  ];
  
# Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}

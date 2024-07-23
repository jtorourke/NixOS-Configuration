# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      <catppuccin/modules/nixos>
    ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
	grub.enable = true;
	grub.version = 2;
	grub.efiSupport = true;
	grub.device = "nodev";
  grub.useOSProber = true; 
  grub.extraConfig = ''
    GRUB_TIMEOUT=60
  '';
	efi.canTouchEfiVariables = true;
  };

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
	home.stateVersion = "24.05";
        # Specify the home-manager configuration file location
        imports = [
          /home/john/.config/home-manager/home.nix
	  <catppuccin/modules/home-manager>
 	];
      };
    };
  };
  
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Budgie Desktop environment.
  services.xserver.displayManager = {
    lightdm = {
      enable = true;
      greeters.slick.enable = true;
      greeters.slick.theme.name = "Gruvbox-Dark";
      greeters.slick.iconTheme.name = "Gruvbox-Plus-Dark";
      background
      = "/home/john/Pictures/gruvbox-wallpapers/wallpapers/minimalistic/gruvbox-rainbow-nix.png";
    };
  };
  services.xserver.desktopManager.budgie.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    emacs
    vim
    neovim
    rofi
    qtile
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
    rstudio
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
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    xorg.xrandr
    os-prober
    emacs
    vim
    neovim
    rofi
    qtile
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
    rstudio
    rustc
    git
    cargo
    spotify
    discord
    qmk
    vial
    iosevka
    font-awesome
    nerdfonts
    morgen
    protonmail-bridge
    home-manager
    font-manager
    catppuccin

    # Theming
    gruvbox-gtk-theme
    gruvbox-plus-icons
  ];

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
  # services.openssh.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

}

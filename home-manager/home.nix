{ config, pkgs, lib, ... }:

with lib;

let
  hyprlock = pkgs.hyprlock;
  inherit (pkgs) hyprland;
  master_layout = pkgs.writeShellScriptBin "master_layout" (builtins.readFile ./scripts/master_layout.sh);
  dwindle_layout = pkgs.writeShellScriptBin "dwindle_layout" (builtins.readFile ./scripts/dwindle_layout.sh);
  custom = {
      font = "IosevkaTerm Nerd Font Mono";
      font_size = "18px";
      font_weight = "bold";
      text_color = "#FBF1C7";
      background_0 = "#1D2021";
      background_1 = "#282828";
      border_color = "#928374";
      red = "#CC241D";
      green = "#98971A";
      yellow = "#FABD2F";
      blue = "#458588";
      magenta = "#B16286";
      cyant = "#689D6A";
      orange = "#D65D0E";
      opacity = "1";
      indicator_height = "2px"; 
      hyprlock_text = "rgb(251, 241, 199)";
      global_font = "IosevkaTerm Nerd Font Mono";
    };
    doom-emacs = import ( pkgs.fetchFromGitHub {
        owner = "doomemacs";
        repo = "doomemacs";
        rev = "5ad99220b86ae1bf421861dfad24492d768ac4d9";
        hash = "sha256-MDYRRTPP5JlETi58REXECnA1ATF1MmU6givDRoyavrg=";
      }
    );
in
{
  home.username = "john";  # Replace with your actual username
  home.homeDirectory = "/home/john";  # Adjust the path if necessary
  home.stateVersion = "25.05";
  home.sessionVariables = {
    EDITOR = "vim";
    #BROWSER = "floorp";
    GTK_THEME = "Gruvbox Material Dark Medium";
    DOOMDIR = "$HOME/.config/doom";
    DOOMLOCALDIR = "$HOME/.emacs.d/.local";
  };
  home.packages = with pkgs; [
    dwindle_layout
    master_layout
    rofi-wayland
    binutils
    gnutls
    zstd
    editorconfig-core-c
    ripgrep
    fd
    (ripgrep.override { withPCRE2 = true; })
  ];
  
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 16;
  };

#  home.file.".config/doom" = {
#    source = builtins.fetchGit {
#      url = "https://github.com/jtorourke/Doom_Emacs";
#      ref = "main";
#    };
#    recursive = true;
#  };

#  programs.emacs = {
#    enable = true;
#    extraPackages = epkgs: [
#      epkgs.vterm
#      epkgs.pdf-tools
#    ];
#  };

#  programs.doom-emacs = {
#    enable = true;
#    doomPrivateDir = inputs.doom-config; # Reference the fetched Doom config
#    emacsPackage = pkgs.emacs-unstable; # Ensure Emacs version matches
#  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "FiraCode Nerd Font" ];
      monospace = [ "IosevkaTerm Nerd Font Mono" ];
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme.override {
        colorVariants = [ "dark" ];
      };
    };
    font = {
      name = "IosevkaTerm Nerd Font Mono";
      size = 12;
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    cursorTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    gtk2 = {
      extraConfig = ''
        gtk-application-prefer-dark-theme = 1
      '';
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "jtorourke";
    userEmail = "johnt@orourke.one";
    aliases = {
      cm = "commit";
      co = "checkout";
      s = "status";
    };
  };

  programs.lazygit = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

#  services.hypridle = {
#    enable = true;
#  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    # nvidiaPatches = true;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    #monitor = "Monitor Unknown-1, disable";
    settings = {
      exec-once = [
        "home-manager switch &"
        "[workspace 1 silent] kitty &"
        "[workspace 1 silent] app.zen_browser.zen &"
        #"[workspace 2 silent] emacs &"
        #"[workspace 4 silent] vesktop &"
        #"[workspace 4 silent] spotify &"
        #"[workspace 5 silent] obs &"
        "nix-shell /etc/nixos/jupyter.nix &"
        "udiskie &"
        "waybar &"
        "hypridle &"
        "hyprpaper &"
        "nm-applet"
      ];

      monitor = "Monitor Unknown-1, disable";

      general = {
        gaps_in = 5;
        gaps_out = 15;
        border_size = 3;
        "col.active_border" = "rgb(8ec07c) rgb(689d6a) 45deg";
        "col.inactive_border" = "rgb(3c3836) rgb(32302f) 45deg";
        layout = "dwindle";
        #border_part_of_window = false;
        no_border_on_floating = false;
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
      };

      dwindle = {
        #no_gaps_when_only = true;
        force_split = 0;
        special_scale_factor = 1.0;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        pseudotile = "yes";
        preserve_split = "yes";
      };

      master = {
        new_status = "master";
        special_scale_factor = 1;
        #no_gaps_when_only = false;
        #always_center_master = true;
        orientation = "center";
      };

      decoration = {
        shadow = {
          offset = "0 0";
          color = "rgb(231,215,173)";
        };
      };

      "$mainMod" = "SUPER";

      animations = {
        enabled = true;

        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeinoutsine, 0.37, 0, 0.63, 1"
        ];

        animation = [
          # Windows
          "windowsIn, 1, 3, easeOutCubic, popin 30%" # window open
          "windowsOut, 1, 3, fluent_decel, popin 70%" # window close.
          "windowsMove, 1, 2, easeinoutsine, slide" # everything in between, moving, dragging, resizing.

          # Fade
          "fadeIn, 1, 3, easeOutCubic" # fade in (open) -> layers and windows
          "fadeOut, 1, 2, easeOutCubic" # fade out (close) -> layers and windows
          "fadeSwitch, 0, 1, easeOutCirc" # fade on changing activewindow and its opacity
          "fadeShadow, 1, 10, easeOutCirc" # fade on changing activewindow for shadows
          "fadeDim, 1, 4, fluent_decel" # the easing of the dimming of inactive windows
          "border, 1, 2.7, easeOutCirc" # for animating the border's color switch speed
          "borderangle, 1, 30, fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
          "workspaces, 1, 4, easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
        ];
      };

      bind = [
        # Programs
        "$mainMod, b, exec, app.zen_browser.zen"
        "$mainMod, t, exec, kitty"
        "$mainMod, r, exec, rofi -show drun"
        "$mainMod, l, exec, hyprlock"
        "$mainMod, s, exec, spotify"
        "$mainMod, v, exec, vesktop"
        "$mainMod, p, exec, rofi -show p -modi p:'rofi-power-menu'"
        "$mainMod, n, exec, nautilus"
        "$mainMod, m, exec, morgen"
        "$mainMod, e, exec, emacs"

        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"

        # same as above, but switch to the workspace
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1" # movetoworkspacesilent
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod CTRL, c, movetoworkspace, empty"

        # Window Focus
        "$mainMod SHIFT, h, movefocus, l"
        "$mainMod SHIFT, l, movefocus, r"
        "$mainMod SHIFT, k, movefocus, u"
        "$mainMod SHIFT, j, movefocus, d"

        # Window Control
        "$mainMod, Q, killactive,"
        "$mainMod, F, fullscreen, 0"
        "$mainMod SHIFT, F, fullscreen, 1"
        "$mainMod, Space, togglefloating,"
        "$mainMod, Space, centerwindow,"
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod CTRL, left, resizeactive, -80 0"
        "$mainMod CTRL, right, resizeactive, 80 0"
        "$mainMod CTRL, up, resizeactive, 0 -80"
        "$mainMod CTRL, down, resizeactive, 0 80"
        "$mainMod ALT, left, moveactive,  -80 0"
        "$mainMod ALT, right, moveactive, 80 0"
        "$mainMod ALT, up, moveactive, 0 -80"
        "$mainMod ALT, down, moveactive, 0 80"

        # Misc. Binds
        ## Screenshots
        "$mainMod, g, exec, grimblast --freeze save area ~/Pictures/$(date +'%m-%d-%Y-At-%Ih%Mm%Ss').png"
        "$mainMod SHIFT, g, exec, grimblast --freeze copy area"

        ## Layout Swapping
        "$mainMod SHIFT, w, exec, dwindle_layout"
        "$mainMod CTRL, w, exec, master_layout"
      ];
      
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # windowrule
      #windowrule = [
      #  "float,qView"
      #  "center,qView"
      #  "size 1200 800,qView"
      #  "float,audacious"
      #  "center,audacious"
      #  "size 1200 800,audacious"
      #  "float,pavucontrol"
      #  "center,pavucontrol"
      #  "size 1200 800,pavucontrol"
      #  "float,^(rofi)$"
      #  "workspace 5,obs"
      #  "workspace 4,spotify"
      #  "workspace 4,vesktop"
      #];

      windowrulev2 = [
        # qView rules
        "float,class:^(qView)$"
        "move center,class:^(qView)$"
        "size 1200 800,class:^(qView)$"

        # audacious rules
        "float,class:^(audacious)$"
        "move center,class:^(audacious)$"
        "size 1200 800,class:^(audacious)$"

        # pavucontrol rules
        "float,class:^(pavucontrol)$"
        "move center,class:^(pavucontrol)$"
        "size 1200 800,class:^(pavucontrol)$"

        # rofi rule
        "float,class:^(rofi)$"

        # Workspace rules
        "workspace 5,class:^(obs)$"
        "workspace 4,class:^(spotify)$"
        "workspace 4,class:^(vesktop)$"
      ];
    };
    extraConfig = ''
      $browser = firefox
      $term = kitty
      $power_menu = rofi -show p -modi p:'rofi-power-menu'
      $rofi = rofi -show drun
      $files = nautilus
      monitor = DP-2, 3440x1440@165, 0x0, 1
    '';
  };

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      position = "top";
      layer = "top";
      height= 30;
      margin-top= 0;
      margin-bottom= 0;
      margin-left= 0;
      margin-right= 0;
      modules-left= [
          "custom/launcher"
          "hyprland/workspaces"
          "tray"
      ];
      modules-center= [
          "clock"
      ];
      modules-right= [
          "cpu"
          "memory"
          "disk"
          "pulseaudio"
          "battery"
          "network"
          "custom/notification"
      ];
      clock= {
          calendar = {
            format = { today = "<span color='#98971A'><b>{}</b></span>";};
          };
          format = "  {:%H:%M}";
          icon-size = 20;
          tooltip= "true";
          tooltip-format= "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt= "  {:%m/%d/%Y}";
        };
      "hyprland/workspaces"= {
          active-only= false;
          disable-scroll= true;
          format = "{icon}";
          on-click= "activate";
          format-icons= {
              "1"= "I";
              "2"= "II";
              "3"= "III";
              "4"= "IV";
              "5"= "V";
              sort-by-number= true;
          };
          persistent-workspaces = {
              "1"= [];
              "2"= [];
              "3"= [];
              "4"= [];
              "5"= [];
          };
      };
      memory= {
          format= "󰟜 {}%";
          format-alt= "󰟜 {used} GiB"; # 
          interval= 2;
          icon-size = 16;
      };
      cpu= {
          format= "  {usage}%";
          format-alt= "  {avg_frequency} GHz";
          interval= 2;
          icon-size = 16;
        };
      disk = {
          # path = "/";
          format = "󰋊 {percentage_used}%";
          interval= 60;
          icon-size = 16;
      };
      network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰀂 {bandwidthUpBytes}/{bandwidthDownBytes}";
          tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "󰖪 ";
          icon-size = 16;
      };
      tray= {
          icon-size= 20;
          spacing= 8;
      };
      pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "  {volume}%";
          format-icons = {
              default = [" "];
          };
          scroll-step = 5;
          icon-size = 16;
          on-click = "pavucontrol";
      };
      battery = {
          format = "{icon} {capacity}%";
          format-icons = [" " " " " " " " " "];
          format-charging = " {capacity}%";
          format-full = " {capacity}%";
          format-warning = " {capacity}%";
          interval = 5;
          states = {
              warning = 20;
          };
          format-time = "{H}h{M}m";
          tooltip = true;
          tooltip-format = "{time}";
          icon-size = 16;
      };
      "custom/launcher"= {
          format= "";
          icon-size = 16;
          on-click= "rofi -show drun";
          on-click-right= "hyprpicker -a --format=hex";
          tooltip= "false";
      };
      "custom/notification" = {
          tooltip = false;
          format = "{icon} ";
          format-icons = {
              notification = "<span foreground='red'><sup></sup></span>  ";
              none = "  ";
              dnd-notification = "<span foreground='red'><sup></sup></span>  ";
              dnd-none = "  ";
              inhibited-notification = "<span foreground='red'><sup></sup></span>  ";
              inhibited-none = "  ";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>  ";
              dnd-inhibited-none = "  ";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
    };
    style = with custom; ''
      * {
           border: none;
           border-radius: 0px;
           padding: 0;
           margin: 0;
           font-family: ${font};
           font-weight: ${font_weight};
           opacity: ${opacity};
           font-size: ${font_size};
         }

         window#waybar {
           background: ${background_0};
         }

         tooltip {
           background: ${background_1};
           border: 1px solid ${border_color};
         }
         tooltip label {
           margin: 5px;
           color: ${text_color};
         }

         #workspaces {
           padding-left: 15px;
         }
         #workspaces button {
           color: ${yellow};
           padding-left:  5px;
           padding-right: 5px;
           margin-right: 10px;
           border-bottom: ${indicator_height} solid ${background_0};
         }
         #workspaces button.empty {
           color: ${text_color};
         }
         #workspaces button.active {
           color: ${yellow};
           border-bottom: ${indicator_height} solid ${yellow};
         }

         #clock {
           color: ${text_color};
           border-bottom: ${indicator_height} solid ${background_0};
         }

         #tray {
           margin-left: 10px;
           color: ${text_color};
         }
         #tray menu {
           background: ${background_1};
           border: 1px solid ${border_color};
           padding: 8px;
         }
         #tray menuitem {
           padding: 1px;
         }

         #pulseaudio, #network, #cpu, #memory, #disk, #battery, #custom-notification {
           padding-left: 5px;
           padding-right: 5px;
           margin-right: 10px;
           color: ${text_color};
         }

         #cpu {
           border-bottom: ${indicator_height} solid ${green};
         }
         #memory {
           border-bottom: ${indicator_height} solid ${cyant};
         }
         #disk {
           border-bottom: ${indicator_height} solid ${orange};
         }

         #pulseaudio {
           margin-left: 15px;
           border-bottom: ${indicator_height} solid ${blue};
         }
         #battery {
           border-bottom: ${indicator_height} solid ${yellow};
         }
         #network {
           border-bottom: ${indicator_height} solid ${magenta};
         }

         #custom-notification {
           margin-left: 15px;
           padding-right: 2px;
           margin-right: 5px;
           border-bottom: ${indicator_height} solid ${red};
         }

         #custom-launcher {
           font-size: 20px;
           color: ${text_color};
           font-weight: bold;
           margin-left: 15px;
           padding-right: 10px;
           border-bottom: ${indicator_height} solid ${background_0};
         }
    '';
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
      preload
      = [ "/home/john/wallpapers/gruvbox-wallpapers/wallpapers/minimalistic/gruv-mistakes.png" ];
      wallpaper = [
        ",/home/john/wallpapers/gruvbox-wallpapers/wallpapers/minimalistic/gruv-mistakes.png"
      ];
    };
  };

  programs.hyprlock = with custom; {
    enable = true;
    settings = {

      # General Items
      general = {
        disable_loading_bar = false;
        grace = 0;
        hide_cursor = true;
        no_fade_in = false;
      };

      # Background and Shading
      background = {
        path
        = "/home/john/wallpapers/gruvbox-wallpapers/wallpapers/anime/joyboy.png";
        blur_passes = 1;
        blur_size = 8;
        contrast = 0.85;
        brightness = 0.80;
        vibrancy = 0.15;
        vibrancy_darkness = 0.0;
      };

      # User Box and label
      shape = {
        size = "350, 50";
        color = "rgb(40, 40, 40)";
        rounding = 15;
        border_size = 1;
        border_color = "rgb(235, 219, 178)";
        rotate = 0;
        position = "0, -20";
        halign = "center";
        valign = "center";
      };
      label = {
        text = "$USER";
        color = "rgb(235, 219, 178)";
        font_size = 16;
        font_family = "${global_font}";
        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      # Input Field (duh)
      input-field = {
        size = "200, 50";
        position = "0, -100";
        monitor = "";
        dots_center = true;
        dots_rounding = -2;
        rounding = -1;
        fade_on_empty = false;
        font_color = "rgb(235, 219, 178)";
        inner_color = "rgb(40,40,40)";
        outer_color = "rgb(255, 255, 255)";
        outline_thickness = 1;
        placeholder_text = "Enter Password";
        shadow_passes = 0;
      };
    };
    extraConfig = ''
    label {
      monitor = 
      text = $TIME
      color = rgba(235, 219, 178, .9)
      font_size = 120
      font_family = IosevkaTerm Nerd Font Mono
      position = 0, 270
      halign = center
      valign = center
    }
    label {
      monitor = 
      text = cmd[update:1000] echo "- $(date +"%A, %B %d") -"
      color = rgba(235, 219, 178, .9)
      font_size = 20
      font_family = IosevkaTerm Nerd Font Mono
      position = 0, 150
      halign = center
      valign = center
    }
    '';
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "IosevkaTerm Nerd Font Mono";
      size = 12;
    };
    themeFile = "GruvboxMaterialDarkMedium";
    shellIntegration = {
      enableZshIntegration = true;
    };
    keybindings = {
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+c" = "copy_to_clipboard";
      "shift+insert" = "paste_from_selection";
      "ctrl+0" = "reset_font_size";
      "ctrl+=" = "increase_font_size";
      "ctrl++" = "increase_font_size";
      "ctrl+-" = "decrease_font_size";
      "shift+page_up" = "scroll_page_up";
      "shift+page_down" = "scroll_page_down";
      "shift+home" = "scroll_to_top";
      "shift+end" = "scroll_to_bottom";
      "ctrl+l" = "clear_scrollback";
    };
  };

  programs.starship = with custom; {
    enable = false;
    #enableZshIntegration = false;
    #settings = pkgs.lib.importTOML ../starship.toml;
  };


  programs.zsh = with custom; {
    enable = true;
    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.config/home-manager";
      theme = "jonathan";
    };
    #catppuccin.enable = true;
    # Other Zsh configurations...

    initContent = ''
      autoload -U colors && colors
      [ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
      [ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
      autoload -U compinit
      zstyle ':completion:*' menu select
      zmodload zsh/complist
      compinit
      _comp_options+=(globdots)
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -v '^?' backward-delete-char
      export KEYTIMEOUT=1  
      export FUNCNEST=1000

      # Define a function to set KEYMAP if not defined
      function zle-keymap-select {
        local current_keymap={${KEYMAP:-main}:#*vicmd*}
        if [[ -n $current_keymap || $1 == 'block' ]]; then
          echo -ne '\e[1 q'
        elif [[ -z $current_keymap || $1 == 'beam' ]]; then
          echo -ne '\e[5 q'
        fi
      }

      #type starship_zle-keymap-select >/dev/null || \
      #{
      #  echo "Load starship"
      #  eval "$(/usr/local/bin/starship init zsh)"
      #}

      zle -N zle-keymap-select
      zle-line-init() {
        zle -K viins
        echo -ne "\\e[5 q"
      }
      zle -N zle-line-init
      echo -ne '\e[5 q'
      preexec() { echo -ne '\e[5 q' ;}
      lfcd () {
        tmp="$(mktemp)"
        lf -last-dir-path="$tmp" "$@"
        if [ -f "$tmp" ]; then
          dir="$(cat "$tmp")"
          rm -f "$tmp"
          if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
              cd "$dir"
            fi
          fi
        fi
      }
      bindkey -s '^o' 'lfcd\n'
      
      # Other aliases and settings
      HISTSIZE=5000
      HISTFILE=~/.zsh_history
      SAVEHIST=5000
      export EDITOR=vim
      # source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
      ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')
      alias nb="sudo nixos-rebuild switch"
      alias ngc="sudo nix-collect-garbage -d 7d"
      alias hb="home-manager switch"
      alias cdd="cd .."
      alias rm="rm -i"
      alias mv="mv -i"
      alias gs="git status"
      alias hme="cd /home/john"
      alias vimr="vim ~/.vimrc"
      alias zshr="vim ~/.zshrc"
      alias star="vim .config/starship.toml"
      alias pyt="python3"
      alias la="ls -a"
      alias ll="ls -al"
      alias crone="crontab -e"
      alias cronl="crontab -l"
      alias doom="~/.emacs.d/bin/doom"
      alias hc="vim .config/home-manager/home.nix"
      alias nc="sudo vim /etc/nixos/configuration.nix"
      alias rebuild="sudo nixos-rebuild switch && home-manager switch"
	
      # Initialize Starship prompt
      #eval "$(starship init zsh)"

      eval "$(direnv hook zsh)"

      # Add local binaries to PATH
      PATH="$HOME/.local/bin:$PATH"

      # Add doom
      PATH="$HOME/.emacs.d/bin:$PATH"
    '';
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ nvchad nvchad-ui gruvbox-nvim colorizer obsidian-nvim catppuccin-vim
    lightline-vim vimwiki vim-orgmode nerdtree vim-nerdtree-syntax-highlight
    vim-nerdtree-tabs julia-vim python-mode python-syntax ];
    extraConfig = ''
      let mapleader = "\Space"
      set nocompatible
      filetype off
      syntax on
      filetype plugin indent on
      set modelines=0
      set wrap
      nnoremap <F2> :set invpaste paste?<CR>
      imap <F2> <C-O>:set invpaste paste?<CR>
      set pastetoggle=<F2>
      set textwidth=79
      set formatoptions=tcqrn1
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set expandtab
      set noshiftround
      set scrolloff=5
      set backspace=indent,eol,start
      set ttyfast
      set laststatus=2
      set showmode
      set showcmd
      set matchpairs+=<:>
      set list
      set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
      set number
      set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}
      set encoding=utf-8
      set hlsearch
      set incsearch
      set ignorecase
      set smartcase
      set viminfo='100,<9999,s100
      nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\\<Space>")<CR>
      vnoremap <Space> zf
      autocmd BufWinLeave *.* mkview
      autocmd BufWinEnter *.* silent loadview"
      map <F7> :w <CR> :!gcc % -o %< && ./%< <CR>
      autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
      autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
      nnoremap tj   :tabnext<CR>
      nnoremap tk   :tapprev<CR>
      nnoremap td   :tabclose<CR>
      nnoremap tn   :tabnew<CR>
      set bg=dark
      colorscheme gruvbox
      let g:lightline = {}
      let g:lightline.colorscheme = 'gruvbox'
      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
      nnoremap <F4> :NERDTreeToggle<CR>
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    '';
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
    # catppuccin.enable = true;
    plugins = with pkgs.vimPlugins; [ gruvbox tabular vim-markdown colorizer catppuccin-vim lightline-vim vimwiki vim-orgmode nerdtree vim-nerdtree-syntax-highlight vim-nerdtree-tabs julia-vim python-mode python-syntax orgmode ];
    extraConfig = ''
      let mapleader = "\Space"
      set nocompatible
      filetype off
      syntax on
      filetype plugin indent on
      set modelines=0
      set wrap
      nnoremap <F2> :set invpaste paste?<CR>
      imap <F2> <C-O>:set invpaste paste?<CR>
      set pastetoggle=<F2>
      set textwidth=79
      set formatoptions=tcqrn1
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set expandtab
      set noshiftround
      set scrolloff=5
      set backspace=indent,eol,start
      set ttyfast
      set laststatus=2
      set showmode
      set showcmd
      set matchpairs+=<:>
      set list
      set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
      set number
      set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}
      set encoding=utf-8
      set hlsearch
      set incsearch
      set ignorecase
      set smartcase
      set viminfo='100,<9999,s100
      nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\\<Space>")<CR>
      vnoremap <Space> zf
      autocmd BufWinLeave *.* mkview
      autocmd BufWinEnter *.* silent loadview"
      map <F7> :w <CR> :!gcc % -o %< && ./%< <CR>
      autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
      autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
      nnoremap tj   :tabnext<CR>
      nnoremap tk   :tapprev<CR>
      nnoremap td   :tabclose<CR>
      nnoremap tn   :tabnew<CR>
      set bg=dark
      colorscheme gruvbox
      let g:lightline = {
        \ 'colorscheme': 'catppuccin_mocha',
      \}
      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
      nnoremap <F4> :NERDTreeToggle<CR>
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    '';
  };
  xdg.configFile."rofi/theme.rasi".text = ''
    * {
      bg-col: #1D2021;
      bg-col-light: #282828;
      border-col: #928374;
      selected-col: #3C3836;
      green: #689D6A;
      fg-col: #FBF1C7;
      fg-col2: #EBDBB2;
      grey: #BDAE93;
      highlight: @green;
    }
  '';

  xdg.configFile."rofi/config.rasi".text = ''
    configuration{
      modi: "run,drun,window";
      lines: 5;
      cycle: false;
      font: "IosevkaTerm Nerd Font Mono 14";
      show-icons: true;
      icon-theme: "Gruvbox-Plus-Dark";
      terminal: "kitty";
      drun-display-format: "{icon} {name}";
      location: 0;
      disable-history: true;
      hide-scrollbar: true;
      display-drun: " Apps ";
      display-run: " Run ";
      display-window: " Window ";
      /* display-Network: " Network"; */
      sidebar-mode: true;
      sorting-method: "fzf";
    }

    @theme "theme"

    element-text, element-icon , mode-switcher {
      background-color: inherit;
      text-color:       inherit;
    }

    window {
      height: 480px;
      width: 400px;
      border: 3px;
      border-color: @border-col;
      background-color: @bg-col;
    }

    mainbox {
      background-color: @bg-col;
    }

    inputbar {
      children: [prompt,entry];
      background-color: @bg-col-light;
      border-radius: 5px;
      padding: 0px;
    }

    prompt {
      background-color: @green;
      padding: 4px;
      text-color: @bg-col-light;
      border-radius: 3px;
      margin: 10px 0px 10px 10px;
    }

    textbox-prompt-colon {
      expand: false;
      str: ":";
    }

    entry {
      padding: 6px;
      margin: 10px 10px 10px 5px;
      text-color: @fg-col;
      background-color: @bg-col;
      border-radius: 3px;
    }

    listview {
      border: 0px 0px 0px;
      padding: 6px 0px 0px;
      margin: 10px 0px 0px 6px;
      columns: 1;
      background-color: @bg-col;
    }

    element {
      padding: 8px;
      margin: 0px 10px 4px 4px;
      background-color: @bg-col;
      text-color: @fg-col;
    }

    element-icon {
      size: 28px;
    }

    element selected {
      background-color:  @selected-col ;
      text-color: @fg-col2  ;
      border-radius: 3px;
    }

    mode-switcher {
      spacing: 0;
    }

    button {
      padding: 10px;
      background-color: @bg-col-light;
      text-color: @grey;
      vertical-align: 0.5;
      horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg-col;
      text-color: @green;
    }
  '';
}

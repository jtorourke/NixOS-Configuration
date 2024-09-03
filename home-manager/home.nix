{ config, pkgs, ... }:

let
  hyprlock = pkgs.hyprlock;
  inherit (pkgs) hyprland;
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
in
{
  home.username = "john";  # Replace with your actual username
  home.homeDirectory = "/home/john";  # Adjust the path if necessary
  home.stateVersion = "24.05";
  home.sessionVariables = {
    EDITOR = "vim";
    GTK_THEME = "Gruvbox Material Dark Medium";
  };

  programs.emacs = {
    enable = true;
    #extraPackages = pkgs: [
    #  doom-emacs
    #];
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
        "waybar &"
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
#        layout = dwindle;
        border_part_of_window = false;
        no_border_on_floating = false;
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
      };

      decoration = {
        shadow_offset = "0 0";
        "col.shadow" = "rgb(231,215,173)";
      };

      "$mainMod" = "SUPER";

      bind = [
        # Programs
        "$mainMod, b, exec, firefox"
        "$mainMod, t, exec, kitty"
        "$mainMod, r, exec, rofi -show drun"
        "$mainMod, l, exec, hyprlock"
        "$mainMod ALT, l, exec, $power_menu"

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

        # Misc. Binds

      ];
    };
    extraConfig = ''
      $browser = firefox
      $term = kitty
      $power_menu = rofi -show p -modi p:'rofi-power-menu'
      $rofi = rofi -show drun
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
      };
      cpu= {
          format= "  {usage}%";
          format-alt= "  {avg_frequency} GHz";
          interval= 2;
      };
      disk = {
          # path = "/";
          format = "󰋊 {percentage_used}%";
          interval= 60;
      };
      network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰀂 {bandwidthUpBytes}/{bandwidthDownBytes}";
          tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "󰖪 ";
      };
      tray= {
          icon-size= 20;
          spacing= 8;
      };
      pulseaudio= {
          format= "{icon} {volume}%";
          format-muted= "  {volume}%";
          format-icons= {
              default= [" "];
          };
          scroll-step= 5;
          on-click= "pavucontrol";
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
      };
      "custom/launcher"= {
          format= "";
          on-click= "rofi -show drun";
          on-click-right= "wallpaper-picker";
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
      = [ "/home/john/Pictures/gruvbox-wallpapers/wallpapers/minimalistic/gruvbox-rainbow-nix.png" ];
      wallpaper = [
        ",/home/john/Pictures/gruvbox-wallpapers/wallpapers/minimalistic/gruvbox-rainbow-nix.png"
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
        = "/home/john/Pictures/gruvbox-wallpapers/wallpapers/minimalistic/haz-mat.png";
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
    theme = "Gruvbox Material Dark Medium";
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


  programs.zsh = {
    enable = true;
    #catppuccin.enable = true;
    # Other Zsh configurations...

    initExtra = ''
      autoload -U colors && colors
      PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
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
      alias nixb="sudo nixos-rebuild switch"
      alias homeb="home-manager switch"
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
      alias homeconf="vim .config/home-manager/home.nix"
      alias nixconf="sudo vim /etc/nixos/configuration.nix"
	
      # Initialize Starship prompt
      # eval "$(starship init zsh)"
      
      # Add local binaries to PATH
      PATH="$HOME/.local/bin:$PATH"
    '';
  };

  programs.neovim = {
    enable = false;
    # Configure Neovim options here
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
    # catppuccin.enable = true;
    plugins = with pkgs.vimPlugins; [ gruvbox colorizer catppuccin-vim
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
      let g:lightline = {
        \ 'colorscheme': 'catppuccin_mocha',
      \}
      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
      nnoremap <F4> :NERDTreeToggle<CR>
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    '';
  };

  programs.alacritty = {
    enable = true;
    # catppuccin.enable = true;
    settings = {
      colors.draw_bold_text_with_bright_colors = true;
      window = {
        opacity = 1;
        title = "Alacritty";
        padding = {
          x = 0;
          y = 0;
        };
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
      };
      scrolling = {
        history = 5000;
      };
      font = {
        size = 12;
        normal = {
          family = "IosevkaTerm Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "IosevkaTerm Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "IosevkaTerm Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "IosevkaTerm Nerd Font Mono";
          style = "Bold Italic";
        };
        offset = {
          x = 0;
          y = 1;
        };
      };
      colors = {
        primary = {
          background = "0x282828";
          foreground = "0xe7d7ad";
        };
        normal = {
          black = "0x282828";
          red = "0xcc241d";
          green = "0x98971a";
          yellow = "0xd79921";
          blue = "0x458588";
          magenta = "0xb16286";
          cyan = "0x689d6a";
          white = "0xa89984";
        };
        bright = {
          black = "0x928374";
          red = "0xfb4934";
          green = "0xb8bb26";
          yellow = "0xfabd2f";
          blue = "0x83a598";
          magenta = "0xd3869b";
          cyan = "0x8ec07c";
          white = "0xebdbb2";
        };
      };
      keyboard = {
		bindings = [
        { key = "V"; mods = "Control|Shift"; action = "Paste"; }
        { key = "C"; mods = "Control|Shift"; action = "Copy"; }
        { key = "Insert"; mods = "Shift"; action = "PasteSelection"; }
        { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
        { key = "Equals"; mods = "Control"; action = "IncreaseFontSize"; }
        { key = "Plus"; mods = "Control"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Paste"; action = "Paste"; }
        { key = "Copy"; action = "Copy"; }
        { key = "L"; mods = "Control"; action = "ClearLogNotice"; }
        { key = "L"; mods = "Control"; chars = "\\f"; }
        { key = "PageUp"; mods = "Shift"; action = "ScrollPageUp"; mode = "~Alt"; }
        { key = "PageDown"; mods = "Shift"; action = "ScrollPageDown"; mode = "~Alt"; }
        { key = "Home"; mods = "Shift"; action = "ScrollToTop"; mode = "~Alt"; }
        { key = "End"; mods = "Shift"; action = "ScrollToBottom"; mode = "~Alt"; }
      ];
	  };
    };
  };

#  programs.starship = {
#    enable = true;
#    enableZshIntegration = true;  # Adjust if using a different shell
#    settings = {
#      battery = {
#        full_symbol = "🔋";
#        charging_symbol = "🔌";
#        discharging_symbol = "⚡";
#        display = [
#          {
#            threshold = 30;
#            style = "bold red";
#          }
#        ];
#      };
#
#      character = {
#        error_symbol = "[✖](bold red) ";
#      };
#
#      cmd_duration = {
#        min_time = 10000;  # Show command duration over 10,000 milliseconds (=10 sec)
#        format = " took [$duration]($style)";
#      };
#
#      directory = {
#        truncation_length = 5;
#        format = "[$path]($style)[$lock_symbol]($lock_style) ";
#      };
#
#      git_branch = {
#        format = " [$symbol$branch]($style) ";
#        symbol = "🍣 ";
#        style = "bold yellow";
#      };
#
#      git_commit = {
#        commit_hash_length = 8;
#        style = "bold white";
#      };
#
#      git_state = {
#        #progress_divider = " of ";
#      };
#
#      hostname = {
#        ssh_only = false;
#        format = "<[$hostname]($style)>";
#        trim_at = "-";
#        style = "bold 202";
#        disabled = false;
#      };
#
#      julia = {
#        format = "[$symbol$version]($style) ";
#        symbol = "ஃ ";
#        style = "bold green";
#      };
#
#      package = {
#        disabled = true;
#      };
#
#      python = {
#        format = "[$symbol$version]($style) ";
#        style = "bold green";
#      };
#
#      rust = {
#        format = "[$symbol$version]($style) ";
#        style = "bold green";
#      };
#
#      time = {
#        time_format = "%T";
#        format = "🕙 $time($style) ";
#        style = "bright-white";
#        disabled = false;
#      };
#
#      username = {
#        style_user = "bold 135";
#        show_always = true;
#      };
#    };
#  };
#
  # Add more programs and their configurations as needed
}

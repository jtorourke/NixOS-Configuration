{ config, pkgs, ... }:

{
  home.username = "john";  # Replace with your actual username
  home.homeDirectory = "/home/john";  # Adjust the path if necessary
  home.stateVersion = "24.05";

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
          foreground = "0xebdbb2";
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

  programs.eww = {
    enable = true;
    configDir = ~/.config/eww/bar;
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

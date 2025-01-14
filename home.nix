{
  config,
  pkgs,
  ...
}: rec {
  home.username = "nicolas";
  home.homeDirectory = "/Users/nicolas";

  home.stateVersion = "24.11";

  xdg.enable = true;

  home.packages = with pkgs; [
    vim
    nixd
    alejandra
    transcrypt
    eza
    bat
    fzf
    fd
    openssl
    nodejs
    pnpm
    jq
    ghq
    devbox
    bun
    # fonts
    jetbrains-mono
  ];

  fonts.fontconfig.enable = true;

  xdg.configFile = {
    "ghostty/config".source = ./dotfiles/ghostty/config;
  };

  home.file = {
    "${home.homeDirectory}/.npmrc".source = ./secrets/.npmrc;
  };

  home.sessionVariables = {
    REPOSITORIES_DIR = "${home.homeDirectory}/.ghq";
    NIX_CONFIG_DIR = "${home.homeDirectory}/.nix-dev";
  };

  home.shellAliases = {
    reload = "source ~/.zshrc";
    lpath = "echo $PATH | tr ':' '\n'";
    cat = "bat";
    ls = "eza --color=always --git --group-directories-first";
    la = "eza --color=always --git --group-directories-first --all";
    ll = "eza --color=always --git --group-directories-first --all --long";
    g = "git";
    gg = "lazygit";
    rm = "rm -rf";
    cp = "cp -r";
    c = "clear";
    d = "cd $NIX_CONFIG_DIR";
    y = "yy";
    hm = "home-manager switch --flake $NIX_CONFIG_DIR";
    drb = "darwin-rebuild switch --flake $NIX_CONFIG_DIR";
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Nicolas Rezende";
      userEmail = "git@nicolasrezende.com";
      ignores = [
        ".DS_Store"
        "Thumbs.db"
        "*~"
        "*.swp"
        ".AppleDouble"
        ".LSOverride"
        "._*"
        ".Spotlight-V100"
        ".Trashes"
        ".vimrc.local"
        ".vim/coc-settings.json"
        "tscommand*.txt"
        "npm-debug.log"
        ".worktrees"
      ];
      extraConfig = {
        pull.rebase = true;
        credential.helper = "osxkeychain";
        init.defaultBranch = "main";
        rerere.enabled = "true";
        push.default = "current";
        ghq = {
          root = home.sessionVariables.REPOSITORIES_DIR;
        };
      };
      includes = [
        {
          condition = "hasconfig:remote.*.url:https://gitlab.sydle.com/**";
          contents = {
            user = {
              name = "Nicolas Gomes de Rezende";
              email = "nicolas.rezende@sydle.com";
            };
          };
        }
      ];
    };
    lazygit = {
      enable = true;
      settings = {
        update.method = "never";
        disableStartupPopups = true;
      };
    };
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "base16_transparent";
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
      };
      initExtra = ''
        unalias md

        md() {
          mkdir -p $1
          cd $1
        }

        r() {
          dir_path=$(ghq list -p | fzf)

          if [[ -n "$dir_path" ]]; then
            cd "$dir_path"
          fi
        }

        nuke() {
          git clean -d -X -f
          pnpm install
          pnpm nx run-many -t build
          pnpm install
        }
      '';
    };
  };
}

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
    jetbrains-mono
  ];

  xdg.configFile = {
    "ghostty/config".source = ./dotfiles/ghostty/config;
  };

  home.file = {
    "${home.homeDirectory}/.npmrc".source = ./secrets/.npmrc;
  };

  home.sessionVariables = {
    CODE_DIR = "${home.homeDirectory}/Developer";
    NIX_CONFIG_DIR = "$CODE_DIR/nix-dev";
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
    hm = "home-manager switch --flake $NIX_CONFIG_DIR";
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
      delta = {
        enable = true;
        package = pkgs.delta;
      };
    };
    lazygit = {
      enable = true;
      settings = {
        git.paging.pager = "${pkgs.delta}/bin/delta --paging=never";

        update.method = "never";
        disableStartupPopups = true;
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };
}

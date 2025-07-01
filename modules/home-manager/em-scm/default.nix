{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.em.scm;

  inherit (lib)
    mkEnableOption
    mkIf
    optionals
    ;
in
{
  imports = [ ];

  options = {
    em.scm = {
      git = {
        enable = mkEnableOption "Emile git setup";
      };
      jj = {
        enable = mkEnableOption "Emile jj setup";
      };
    };
  };

  config = {
    home.packages =
      with pkgs;
      builtins.concatLists [
        (optionals cfg.git.enable [ git ])
        (optionals cfg.jj.enable [ jujutsu ])
      ];

    programs.git = mkIf cfg.git.enable {
      enable = true;
      lfs.enable = true;

      # TODO Pass these in from
      userName = "Emile";
      userEmail = "emile.aks@gmail.com";

      signing = {
        signByDefault = true;
        key = "74B3A6C87D8F85E1";
      };

      # TODO Agenix this shit
      includes = [
        {
          # use diffrent email & name for work
          condition = "gitdir:~/Desktop/Andromeda/";
          contents = {
            user = {
              email = "emile@dromeda.com.au";
              name = "Emile Akbarzadeh";
              signingKey = "74B3A6C87D8F85E1";
            };
            commit = {
              gpgSign = true;
            };
          };
        }
      ];

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
      };

      ignores = [

        # macOS
        ".DS_Store"
        ".AppleDouble"
        ".LSOverride"
        "Icon"
        "._*"
        ".Spotlight-V100"
        ".Trashes"
        "ehthumbs.db"
        "Thumbs.db"
      ];

      delta = {
        enable = true;
        options = {
          features = "side-by-side";
        };
      };

      aliases = {
        # common aliases
        br = "branch";
        co = "checkout";
        st = "status";
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
        cm = "commit -m";
        ca = "commit -am";
        dc = "diff --cached";
        amend = "commit --amend -m";

        # aliases for submodule
        update = "submodule update --init --recursive";
        foreach = "submodule foreach";
      };
    };

    programs.jujutsu = mkIf cfg.jj.enable {
      enable = true;
      package = pkgs.jujutsu;
      settings = {
        user = {
          # name = "corncheese";
          # email = "pavel.atanasov2001@gmail.com";
          # name = config.programs.git.userName;
          # email = config.programs.git.userEmail;
          email = "emile.aks@gmail.com";
          name = "Emile";
        };
        git = {
          fetch = [
            "origin"
            "upstream"
          ];
          push = "github";
        };
        signing = {
          backend = "gpg";
          # sign-all = true;
          # key = "675AA7EF13964ACB";
          # sign-all = config.programs.git.signing.signByDefault;
          # key = config.programs.git.signing.key;
          sign-all = true;
          key = "74B3A6C87D8F85E1";
        };
        core.fsmonitor = "watchman";
        ui = {
          color = "always";
          # pager = "nvim";
          editor = "nvim";
        };
        revsets = {
          log = "@ | bases | branches | curbranch::@ | @::nextbranch | downstream(@, branchesandheads)";
        };
        revset-aliases = {
          "bases" = "dev";
          "downstream(x,y)" = "(x::y) & y";
          "branches" = "downstream(trunk(), branches()) & mine()";
          "branchesandheads" = "branches | (heads(trunk()::) & mine())";
          "curbranch" = "latest(branches::@- & branches)";
          "nextbranch" = "roots(@:: & branchesandheads)";
        };
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ emile ];
  };
}

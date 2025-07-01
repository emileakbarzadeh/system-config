{
  inputs,
  lib,
  pkgs,
  config,
  meta,
  ...
}:

{
  imports = [ ];

  config =
    let
      user-info = import ./../users.nix;
    in
    {
      home = {
        username = user-info.emile.username;
        homeDirectory = user-info.emile.home;
        stateVersion = "24.11";
      };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      age.rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJFavq4XR8mBk6lVUuori2tlnnEb2AQkyns/H8lgNoU5 emile@EmilesMacBookAir";
      };

      # age.secrets."test.key".rekeyFile = "${inputs.self}/secrets/test/test.age";

      # warnings = [
      #   "${config.age.secrets."test.key".path} is the key"
      # ];

      # # log conroy into atuin sync
      # age.secrets."corncheese.atuin.key" = {
      #   rekeyFile = "${inputs.self}/secrets/corncheese/atuin/key.age";
      # };
      em = {
        macos.enable = true;
        scm = {
          git.enable = true;
        };

        fonts.enable = true;

        # shell.enable = true;

        shell = {
          enable = true;
          hostname = meta.hostname;
          p10k = true;
          flakePath = "${config.home.homeDirectory}/Documents/MacConf/system-config";
        };

        common-packages.enable = true;

        development = {
          enable = true;
          ssh.enable = true;
          vscode.enable = true;
          electronics.enable = false;
          mechanical.enable = false;
          audio.enable = false;
          csharp.enable = true;
          python.enable = true;
          ios.enable = true;
        };

        desktop = {
          enable = true;
        };
      };

      # corncheese = {
      #   # macos = {
      #   #   enable = true;
      #   # };
      #   # development = {
      #   #   vscode.enable = true;
      #   #   ssh.enable = true;
      #   # };
      #   theming.enable = false;
      #   # desktop = {
      #   #   enable = true;
      #   #   firefox.enable = true;
      #   #   element.enable = true;
      #   # };
      #   # shell = {
      #   #   enable = true;
      #   #   atuin = {
      #   #     enable = true;
      #   #     sync = true;
      #   #     key = config.age.secrets."corncheese.atuin.key".path;
      #   #   };
      #   #   direnv = true;
      #   #   zoxide = true;
      #   #   shells = [ "zsh" ];
      #   # };
      #   # wezterm = {
      #   #   enable = false;
      #   # };
      # };

      # andromeda = {
      #   development.enable = true;
      # };

      # home.packages = with pkgs; [
      #   # Nix
      #   nil
      #   nixfmt-rfc-style
      # ];

      # programs.btop = {
      #   enable = true;
      # };

      # programs.git = {
      #   enable = true;
      #   lfs.enable = true;
      #   userName = "Conroy Cheers";
      #   userEmail = "conroy@corncheese.org";
      #   delta = {
      #     enable = true;
      #   };
      # };

      # programs.kitty = {
      #   enable = true;
      #   settings = {
      #     scrollback_lines = 20000;
      #   };
      # };

      # services.gpg-agent = {
      #   enable = true;
      #   defaultCacheTtl = 1800;
      #   enableSshSupport = true;
      # };

      # home.file.".stack/config.yaml".text = lib.generators.toYAML {} {
      #   templates = {
      #     scm-init = "git";
      #     params = with config.programs.git; {
      #       author-name = userName;
      #       author-email = userEmail;
      #       github-username = userName;
      #     };
      #   };
      #   nix.enable = true;
      # };
    };
}

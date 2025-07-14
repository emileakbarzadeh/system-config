{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.em.nix-standard;
in
{
  # options = {
  #   em.nix-standard = {
  #     enable = lib.mkEnableOption "Nix standard settings";
  #   };
  # };
  options = { };

  imports = [
    # inputs.lix-module.nixosModules.default
  ];

  config = {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = lib.mkDefault true;

    # enable flakes globally
    nix = lib.mkDefault {

      # TODO doesnt work on nix-darwin, make a platform switch
      # settings.experimental-features = [
      #   "nix-command"
      #   "flakes"
      # ];
      # TODO(em): Agenix this + seperate into seperate module in common
      # TODO(em): Add aws config (in ~root/.aws) to nix config
      settings = {
        substituters = [ "s3://andromedarobotics-artifacts?region=ap-southeast-2" ];
        trusted-public-keys = [
          "nix-cache.dromeda.com.au-1:x4QtHKlCwaG6bVGvlzgNng+x7WgZCZc7ctrjlz6sDHg="
        ];
      };

      extraOptions = ''
        experimental-features = nix-command flakes
        # extra-platforms = x86_64-darwin aarch64-darwin
      '';

      package = pkgs.nix-monitored;

      # do garbage collection weekly to keep disk usage low
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };

      # Disable auto-optimise-store because of this issue:
      #   https://github.com/NixOS/nix/issues/7273
      # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
      settings = {
        auto-optimise-store = false;
      };
    };
  };
}

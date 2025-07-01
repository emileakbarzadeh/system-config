{
  pkgs,
  lib,
  config,
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

  config = {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = lib.mkDefault true;

    # enable flakes globally
    nix = lib.mkDefault {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      package = pkgs.nix;

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

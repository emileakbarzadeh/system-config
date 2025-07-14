{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  config =
    let
      experimentalConfig = [
        "nix-command"
        "flakes"
      ];
    in
    lib.mkMerge [
      {
        nixpkgs.config.allowUnfree = lib.mkDefault true;

        # enable flakes globally
        nix = lib.mkDefault {

          # TODO(em): Agenix this + seperate into seperate module in common
          # TODO(em): Add aws config (in ~root/.aws) to nix config
          settings = {
            substituters = [ "s3://andromedarobotics-artifacts?region=ap-southeast-2" ];
            trusted-public-keys = [
              "nix-cache.dromeda.com.au-1:x4QtHKlCwaG6bVGvlzgNng+x7WgZCZc7ctrjlz6sDHg="
            ];
          };

          extraOptions = ''
            experimental-features = ${lib.concatStringsSep " " experimentalConfig}
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
      }
      (lib.mkIf (pkgs.stdenv.isDarwin == false) {
        nix.settings.experimental-features = lib.mkDefault experimentalConfig;
      })
    ];
}

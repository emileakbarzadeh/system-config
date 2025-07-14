{ inputs, ... }:
{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.em.builder;
in
{
  imports = [ ];

  options = {
    em.builder = {
      enable = mkEnableOption "Emile MacOS linux builder config";
    };
  };

  config = mkIf cfg.enable {
    # https://nixcademy.com/posts/macos-linux-builder/
    # This line is a prerequisite
    nix.settings.trusted-users = [ "@admin" ];

    nix.linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 4;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 6;
        };
      };
    };
  };
}

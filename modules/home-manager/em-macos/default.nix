{
  inputs,
  config,
  lib,
  pkgs,
  meta,
  ...
}:

let
  cfg = config.em.macos;
in
{
  options = {
    em.macos = {
      enable = lib.mkEnableOption "Emile macOS-specific home-manager config";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      builtins.concatLists [
        [
          # betterdisplay
        ]
      ];
  };

  meta = {
    maintainers = with lib.maintainers; [ emile ];
  };
}

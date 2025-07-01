{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.em.fonts;
in
{
  options = {
    em.fonts = {
      enable = lib.mkEnableOption "font packages";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      meslo-lgs-nf

      # Nerds
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
    ];
  };
}

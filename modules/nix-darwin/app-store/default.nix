{ config, lib, ... }:
let
  cfg = config.em.macos.app-store;
in
{
  options = {
    em.macos.app-store = {
      enable = lib.mkEnableOption "Emile's macOS App Store config";
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      masApps = {
        Xcode = 497799835;
        Velja = 1607635845;
        AppleConfigurator2 = 1037126344;

        DynamixelWizard = 1471288434;
        # Wechat = 836500024;
        # NeteaseCloudMusic = 944848654;
        # QQ = 451108668;
        # WeCom = 1189898970;  # Wechat for Work
        # TecentMetting = 1484048379;
        # QQMusic = 595615424;
      };
    };
  };
}

{
  inputs,
  config,
  lib,
  pkgs,
  meta,
  ...
}:

let
  cfg = config.em.common-packages;
in
{
  options = {
    em.common-packages = {
      enable = lib.mkEnableOption "common packages";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # archives
      zip
      xz
      unzip
      p7zip

      # utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processer https://github.com/mikefarah/yq
      fzf # A command-line fuzzy finder

      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing

      # misc
      cowsay
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      caddy
      gnupg

      # productivity
      glow # markdown previewer in terminal
    ];
  };
}

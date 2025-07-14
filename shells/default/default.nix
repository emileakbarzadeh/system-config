# Shell for bootstrapping flake-enabled nix and other tooling
{ pkgs, inputs, ... }:
let
  pkgs' = import inputs.nixpkgs {
    system = pkgs.system;
    overlays = [ inputs.agenix-rekey.overlays.default ];
  };
in
pkgs.mkShellNoCC {
  NIX_CONFIG = ''
    extra-experimental-features = nix-command flakes
  '';
  nativeBuildInputs = with pkgs; [
    # pkgs.nixVersions.monitored.latest
    home-manager
    git
    wireguard-tools
    deploy-rs
    # inputs.agenix.packages.${pkgs.system}.agenix
    # inputs.ragenix.packages.${pkgs.system}.ragenix
    rage
    pkgs'.agenix-rekey
    age-plugin-fido2-hmac
  ];
}

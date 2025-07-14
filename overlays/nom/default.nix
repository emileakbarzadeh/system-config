{ inputs, ... }:
final: prev: {
  # Build nix-monitored using lix as the pkgs base
  nix-monitored = inputs.nix-monitored.packages.${final.system}.default.override {
    nix = inputs.lix-module.pkgs.${final.system}.lix;
  };

  nixos-rebuild = prev.nixos-rebuild.override {
    nix = inputs.nix-monitored.packages.${final.system}.default;
  };

  nix-direnv = prev.nix-direnv.override {
    nix = inputs.nix-monitored.packages.${final.system}.default;
  };
}

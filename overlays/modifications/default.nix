{ inputs, ... }:

final: prev: {
  lib = prev.lib // {
    maintainers = {
      emile = {
        name = "Emile";
        email = "emile.aks@gmail.com";
        github = "emile";
        githubId = "9310662";
        gitSigningKey = "74B3A6C87D8F85E1";
        keys = [
          {
            # fingerprint = "8A29 0250 C775 7813 1DD1  DC57 7275 0ABE E181 26D0";
          }
        ];
      };
    };
  };

  # Alias nix command to nix-monitored
  nix-monitored = inputs.nix-monitored.packages.${prev.system}.default.override {
    # Install lix
    nix = inputs.lix-module;
    nix-output-monitor = prev.nix-output-monitor;
  };

  nixVersions = prev.nixVersions // {
    monitored = final.lib.concatMapAttrs (
      version: package:
      let
        eval = builtins.tryEval package;
      in
      final.lib.optionalAttrs
        (
          eval.success
          && final.lib.and (final.lib.all (prefix: !final.lib.hasPrefix prefix version)
            # TODO: smarter filtering of deprecated and non-packages
            [
              "nix_2_4"
              "nix_2_5"
              "nix_2_6"
              "nix_2_7"
              "nix_2_8"
              "nix_2_9"
              "nix_2_10"
              "nix_2_11"
              "nix_2_12"
              "nix_2_13"
              "nix_2_14"
              "nix_2_15"
              "nix_2_16"
              "nix_2_17"
              "nix_2_18"
              "nix_2_19"
              "nix_2_20"
              "nix_2_21"
              "nix_2_22"
              "nix_2_23"
              "unstable"
            ]
          ) (final.lib.isDerivation eval.value)
        )
        {
          # NOTE: `lib.getBin` is needed, otherwise the `-dev` output is chosen
          "${version}" = final.lib.getBin (
            inputs.nix-monitored.packages.${final.system}.default.override {
              nix = eval.value;
              nix-output-monitor = prev.nix-output-monitor;
            }
          );
        }
    ) prev.nixVersions;
  };

  river = prev.river.overrideAttrs (oldAttrs: rec {
    xwaylandSupport = true;
  });

  discord = prev.discord.override {
    withOpenASAR = true;
    withVencord = true;
  };
}

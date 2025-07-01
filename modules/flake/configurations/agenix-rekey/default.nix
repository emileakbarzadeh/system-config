{
  inputs,
  lib,
  pkgs,
  config,
  options,
  ...
}:
{
  config = {
    # NOTE: `(r)agenix` and `agenix-rekey` modules are imported by `../../../modules/flake/configurations.nix`
    age.rekey = {
      # NOTE: defined in `meta.nix`
      # hostPubkey       = null;
      masterIdentities = lib.mkDefault [
        {
          identity = "${inputs.self}/secrets/yubikey.hmac";
          pubkey = "age1v6ve5egfrccvdlp36ckjgexq034dghheknaupx2ga4mrucm7xenqc5g76d";
        }
      ];
      storageMode = lib.mkDefault "local";
      localStorageDir = lib.mkDefault "${inputs.self}/secrets/rekeyed/${config.networking.hostName}";
      agePlugins = [ pkgs.age-plugin-fido2-hmac ];
    };
  };
}

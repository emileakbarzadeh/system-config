{
  inputs,
  lib,
  pkgs,
  config,
  options,
  meta,
  ...
}:
{
  config = {
    # Set fixed secrets dirs so we can reference secrets with a constant path
    age = {
      secretsDir = "${config.home.homeDirectory}/.agenix/agenix";
      secretsMountPoint = "${config.home.homeDirectory}/.agenix/agenix.d";
    };
    # NOTE: `(r)agenix` and `agenix-rekey` modules are imported by `../../../modules/flake/configurations.nix`
    age.rekey = {
      # NOTE: defined in user home-manager config
      # hostPubkey       = null;
      masterIdentities = lib.mkDefault [
        {
          identity = "${inputs.self}/secrets/yubikey.hmac";
          pubkey = "age1v6ve5egfrccvdlp36ckjgexq034dghheknaupx2ga4mrucm7xenqc5g76d";
        }
      ];
      storageMode = lib.mkDefault "local";
      localStorageDir = lib.mkDefault "${inputs.self}/secrets/rekeyed/${meta.hostname}/${config.home.username}";
      agePlugins = [ pkgs.age-plugin-fido2-hmac ];
    };
  };
}

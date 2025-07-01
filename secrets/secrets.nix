# This file is not imported into the NixOS/home-manager configurations.
# It is only used for the `agenix` CLI.
# `agenix` use the public keys defined in this file to encrypt the secrets.
# Users can decrypt the secrets by any of the corresponding private keys.

let
  # User's ssh public key:
  #     cat ~/.ssh/id_ed25519.pub
  # Generate using:
  #     ssh-keygen -t ed25519

  yubikey = "age1v6ve5egfrccvdlp36ckjgexq034dghheknaupx2ga4mrucm7xenqc5g76d"; # yubikey FIDO2

  emilesMacBookAir = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJFavq4XR8mBk6lVUuori2tlnnEb2AQkyns/H8lgNoU5 emile@EmilesMacBookAir";
  emilesMacBookPro = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDU5KdbGzMPf1R7YOyl7D/zY6UeuCFASsrX20HkGgrLRY9rBC7padJagOu1GMmd/9Bc6ZB30L/7UE/jpO345YRZlLWGsdQFcAxgGvEACixxSpUDcMUmlfmQuAmG/kWcM5LUt301iMgC+GSdiydETbJKKOnIxxz0+/wZoQB031dz7T+VvTzcoxgbNvu2GGkYZSOUyf2u9Xkj3v81/Qfc2IAbqGNWOVl/8HHWf+oyFPFJhoAd0K+tMFlxcBYe15xQsjGFA6i8fbFor3FsynY0vEn3GVWvcsErKWBHbRmLh1tHNVRc3YVewk6yM8SBiszUNQQmrMDpSI123OPOgLTbWrTh57tqPS1evHluC13GvbsMHpmizZDPcaLsOqsX9cWvLdBzLt5MrlHi3BVO58tbD4UJt4scRYqYH7yCrUKOwg/hIeOo7uvZK6pjzqSmip+mBzc1STlPoa9CNlXMydZvxr/stYWsOJohkZMbRNYl22AiJXxktFeeDJVS3yHGdKhLZr0= conroy@squiggle";

  users = [
    yubikey
    emilesMacBookAir
    emilesMacBookPro
  ];

  # System's ssh public key:
  #    cat /etc/ssh/ssh_host_ed25519_key.pub
  # Generated automatically when running `sshd`

  # kombu_system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdi5yynd4jv2CUqM51TVT0hkPS6osXNc5bLq11dpB/f root@kombu";
  # brick_system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUE2OxmW9PcRNvSY6wXsaxxoXNeRSYM2wj4UXR/pcW/ root@brick";
  # labtop_system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfUubORT1oZ+j5COiJKOUi9Bq7Lvc0vWc9/oIK03w3e root@labtop";
  # systems = [
  #   kombu_system
  #   brick_system
  #   labtop_system
  # ];

in
{
  "andromeda/test/test.age".publicKeys = users;
  # "andromeda/aws-experiments/key.age".publicKeys = users ++ [
  #   kombu_system
  #   brick_system
  #   squiggle_conroy
  # ];
  # "andromeda/tailscale/key.age".publicKeys = users ++ [ kombu_system ];
  # "corncheese/atuin/key.age".publicKeys = users ++ [
  #   kombu_system
  #   brick_system
  #   labtop_system
  #   squiggle_conroy
  # ];
  # "corncheese/home/key.age".publicKeys = users ++ [
  #   kombu_system
  #   brick_system
  #   squiggle_conroy
  # ];
  # "home/conroy/user/password.age".publicKeys = users ++ [
  #   kombu_system
  #   brick_system
  # ];
  # "home/wifi/conf.age".publicKeys = users ++ systems;
}

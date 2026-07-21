{ config, lib, pkgs, ... }:

{
  system.autoUpgrade = {
    enable = lib.mkDefault true;
    allowReboot = lib.mkForce false;
    channel = "https://channels.nixos.org/nixos-unstable";
  };
}

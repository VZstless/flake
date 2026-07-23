{ lib, ... }:

{
  networking.networkmanager.enable = lib.mkForce true;
  networking.networkmanager.dns = "none";
  programs.mtr.enable = lib.mkForce true;
}

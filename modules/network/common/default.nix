{ lib, ... }:

{
  networking.networkmanager.enable = lib.mkForce true;
  networking.networkmanager.dns = "none";
  programs.mtr.enable = lib.mkForce true;

  networking.nameservers = [ 
    "100.100.100.100"
    "8.8.8.8"
    "8.8.4.4"
    "1.1.1.1"
  ];
}

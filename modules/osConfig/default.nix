{ config, lib, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = lib.mkDefault true;
    allowBroken = lib.mkDefault true;
    allowUnsupportedSystem = lib.mkDefault true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.autoUpgrade = {
    enable = lib.mkDefault true;
    allowReboot = lib.mkForce false;
    channel = "https://channels.nixos.org/nixos-unstable";
  };
  system.forbiddenDependenciesRegexes = [
    "-bun-"
    "-bun$"
  ];
}

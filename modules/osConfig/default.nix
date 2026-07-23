# All these are set to make basic configuration between hosts are consistent.
# Or to say, I do not want to modify these variables.

{ lib, pkgs, ... }:

{

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
    memtest86 = {
      enable = true;
      sortKey = "o_memtest86";
    };
    netbootxyz = {
      enable = true;
      sortKey = "o_netbootxyz";
    };
  };

  boot.enableContainers = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings.auto-optimise-store = true;

  boot.binfmt = {
    emulatedSystems = [
      "aarch64-linux"
      "riscv64-linux"
    ];
    preferStaticEmulators = true; # required to work with podman
  };

  security.sudo.enable = true;

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

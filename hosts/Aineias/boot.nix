{ config, pkgs, ... }:

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
}

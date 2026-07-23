# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./boot.nix
      ./intel-graphics.nix
      ./system-packages.nix
      ../../modules/locale
      ../../modules/niri
      ../../modules/osConfig
      ../../modules/desktop
      ../../modules/network
      ../../modules/network/ssh
      ../../modules/network/firefox
    ];

  networking.hostName = "Aineias"; # Define your hostname.

  users.users.root.hashedPassword = "!";
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vzstless = {
    isNormalUser = true;
    description = "VZstless";
    extraGroups = [ "audio" "networkmanager" "wheel" ];
  };

  programs.gnupg = {
    package = pkgs.gnupg;
    agent = {
      enable = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-tty;
    };
  };

  networking.nameservers = [ 
    "100.100.100.100"
    "8.8.8.8"
    "8.8.4.4"
    "1.1.1.1"
  ];

  security.sudo.enable = true;

  # List services that you want to enable:

  services.tailscale.enable = true;

  system.stateVersion = "25.05";

}

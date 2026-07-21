# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./boot.nix
      ./intel-graphics.nix
      ../../modules/locale
      ../../modules/niri
      ../../modules/nixpkgsConfig
      ./system-packages.nix
    ];

  networking.hostName = "Aineias"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  users.users.root.hashedPassword = "!";
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vzstless = {
    isNormalUser = true;
    description = "VZstless";
    extraGroups = [ "audio" "networkmanager" "wheel" ];
  };

  programs.firefox = {
    enable = true;
    package = inputs.firefox.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin;
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
    "192.168.43.1"
    "2409:893d:510d:87b9:f2f8:8ff:fec7:e693"
  ];
  networking.search = [ "example.ts.net" ];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    allowUnsupportedSystem = true;
  };


  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];


  security.sudo.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  # List services that you want to enable:

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      UseDns = false;
    };
  };
  
  system.forbiddenDependenciesRegexes = [
    "-bun-"
    "-bun$"
  ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

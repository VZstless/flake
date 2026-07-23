# Top configuration for Aineias
# which is an Intel Lunar Lake Laptop with intel graphics and mostly
# non developing related system-wide dependencies.

{ osModules, ... }:

{
  imports =  with osModules; [
      gpg
      locale
      niri
      osConfig
      desktop
      network.common
      network.ssh
      network.firefox
      network.tailscale
    ] ++ [
      ./hardware-configuration.nix
      ./system-packages.nix
      ./intel-graphics.nix
    ];

  networking.hostName = "Aineias"; # Define your hostname.

  # default user as vzstless
  users.users.vzstless = {
    isNormalUser = true;
    description = "VZstless";
    extraGroups = [ "audio" "networkmanager" "wheel" ];
  };

  system.stateVersion = "25.05";

}

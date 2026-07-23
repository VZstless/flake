# Top configuration for Aineias
# which is an Intel Lunar Lake Laptop with intel graphics and mostly
# non developing related system-wide dependencies.

{ ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./intel-graphics.nix
      ./system-packages.nix
      ../../modules/gpg
      ../../modules/locale
      ../../modules/niri
      ../../modules/osConfig
      ../../modules/desktop
      ../../modules/network
      ../../modules/network/ssh
      ../../modules/network/firefox
      ../../modules/network/tailscale
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

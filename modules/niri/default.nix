{ lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.niri.lib.internal.settings-module
    inputs.noctalia.nixosModules.default
    ./config.nix
  ];

  services.displayManager.sessionPackages = [ pkgs.niri ];
  environment.systemPackages = with pkgs; [
    xwayland-satellite  # Required for X11 app compatibility
    fuzzel      # App launcher (Super+D opens by default)
    swaylock    # Screen locker (Super+Alt+L locks the screen)
    mako        # Notification daemon
    swaybg      # Wallpaper utility
    nautilus
    quickshell
    gnome-keyring
  ];

  programs.niri = {
    enable = lib.mkForce true;
    useNautilus = true;
  };

  programs.waybar.enable = lib.mkDefault false;          # Waybar status bar (top bar)
  security.polkit.enable = lib.mkDefault true;          # Polkit for authentication dialogs

  # set to enable noctalia-shell
  services.power-profiles-daemon.enable = lib.mkForce true;
  services.upower.enable = lib.mkForce true;

  
  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    recommendedServices.enable = true;
  };
}

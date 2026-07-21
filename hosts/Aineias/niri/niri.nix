{ config, pkgs, ... }:

{
  services.displayManager.sessionPackages = [ pkgs.niri ];
  environment.systemPackages = with pkgs; [
    niri
    xwayland-satellite  # Required for X11 app compatibility
    fuzzel      # App launcher (Super+D opens by default)
    swaylock    # Screen locker (Super+Alt+L locks the screen)
    mako        # Notification daemon
    swaybg      # Wallpaper utility
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  programs.waybar.enable = true;          # Waybar status bar (top bar)
  security.polkit.enable = true;          # Polkit for authentication dialogs
  services.gnome.gnome-keyring.enable = true; # Secret service (for storing passwords)
}

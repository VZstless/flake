{
  self,
  config,
  pkgs,
  ...
}:

let
  wallpaper = "${self}/wallpapers/kiddy-grade.jpg";
in
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;
      settings = {
        "org/gnome/desktop/background" = {
          picture-uri = "file://${wallpaper}";
          picture-uri-dark = "file://${wallpaper}";
          picture-options = "zoom";
        };
      };
    }
  ];
}

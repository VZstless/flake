{ pkgs, ... }:

{
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
}

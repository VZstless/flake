{ inputs, lib, pkgs, ... }:

{
  programs.firefox = {
    enable = lib.mkDefault true;
    package = inputs.firefox.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin;
  };
}

{ config, lib, pkgs, ... }:

{

  networking.hosts."127.0.0.1" = ["Tweedeldee"]; 

  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    vim # or some other editor, e.g. nano or neovim

    hostname
    #gnupg

    git
    fastfetch
    hyfetch
    
    neovim
    # clear: command not found
    ncurses
    fish
    nix-output-monitor

    openssh
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  
  # Set your time zone
  time.timeZone = "Asia/Shanghai";
}

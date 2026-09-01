{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alpine
    alsa-utils
    android-tools
    bat
    binsider
    bird2
    btop
    cloc
    curl
    eog
    element-desktop
    fastfetch
    file
    fish
    frr
    fzf
    git
    git-absorb
    gping
    hyfetch
    inotify-info
    iptables
    just
    kitty
    lazygit
    lsof
    mc
    nixd
    nixfmt
    nix-output-monitor
    nvtopPackages.intel
    obs-studio
    pciutils
    pinentry-all
    wget
    ripgrep
    squashfsTools
    telegram-desktop
    thunderbird
    tinyxxd
    tor-browser
    tree
    typst
    usbutils
    util-linux
    vlc
    weechat
    wireguard-tools
    xonsh
  ];
}

{ config, pkgs, ... }:



{
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
    type = "fcitx5"; 
    enable = true; 
    fcitx5.addons = with pkgs; [ 
      fcitx5-gtk # alternatively, 
      qt6Packages.fcitx5-chinese-addons
      fcitx5-pinyin-moegirl
      fcitx5-pinyin-minecraft
      fcitx5-mozc
      fcitx5-nord # a color theme 
    ]; 
  };

  environment.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
  };

  # 安装中文字体
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans   # Noto 字体
    nerd-fonts.symbols-only
    # Optional: Add a full Nerd Font for terminals and other applications
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

}

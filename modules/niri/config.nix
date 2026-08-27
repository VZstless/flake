# Declarative niri configuration, in the style of niri-flake's
# default-config.kdl.nix:
# https://github.com/sodiboo/niri-flake/blob/main/default-config.kdl.nix
#
# `programs.niri.config` is a KDL document option provided by niri-flake's
# settings module (imported by ./default.nix). It is serialized to
# `programs.niri.finalConfig`, validated with `niri validate` at build time,
# and installed system-wide at /etc/niri/config.kdl.
#
# niri reads $XDG_CONFIG_HOME/niri/config.kdl first and falls back to
# /etc/niri/config.kdl, so remove ~/.config/niri/config.kdl for this config
# to take effect.

{ config, lib, pkgs, inputs, ... }:

let
  inherit (inputs.niri.lib.kdl) node plain leaf flag;
in
{
  programs.niri.config = lib.remove null (lib.flatten [
    (plain "input" [
      (plain "keyboard" [
        # An empty xkb section makes niri fetch xkb settings from
        # org.freedesktop.locale1 (controlled by localectl).
        (plain "xkb" [ ])

        # Enable numlock on startup.
        (flag "numlock")
      ])

      (plain "touchpad" [
        (flag "tap")
        (flag "natural-scroll")
      ])

      (plain "mouse" [
        (leaf "accel-speed" 0.2)
      ])

      (plain "trackpoint" [
        (flag "off")
      ])
    ])

    # The built-in laptop monitor is currently left unconfigured (it was
    # "/-output" in the old config). To pin it, use something like:
    # (node "output" "eDP-1" [
    #   (leaf "mode" "2880x1800@120.000")
    #   (leaf "scale" 1.0)
    #   (leaf "transform" "normal")
    #   (leaf "position" { x = 1280; y = 0; })
    # ])

    # Let the noctalia wallpaper live in the backdrop layer.
    (plain "layer-rule" [
      (leaf "match" { namespace = "^noctalia-wallpaper*"; })
      (leaf "place-within-backdrop" true)
    ])

    (plain "layout" [
      (leaf "background-color" "transparent")

      (leaf "gaps" 10)

      (leaf "center-focused-column" "never")

      # Widths that switch-preset-column-width (Mod+R) toggles between.
      (plain "preset-column-widths" [
        (leaf "proportion" 0.33333)
        (leaf "proportion" 0.5)
        (leaf "proportion" 0.66667)
      ])

      # Default width of new windows.
      (plain "default-column-width" [
        (leaf "proportion" 0.5)
      ])

      (plain "focus-ring" [
        (leaf "width" 4)
        (leaf "active-color" "#7fc8ff")
        (leaf "inactive-color" "#505050")
      ])

      (plain "border" [
        (flag "off")
        (leaf "width" 0)
        (leaf "active-color" "#ffc87f")
        (leaf "inactive-color" "#505050")
        (leaf "urgent-color" "#9b0000")
      ])

      (plain "shadow" [
        (leaf "softness" 30)
        (leaf "spread" 5)
        (leaf "offset" { x = 0; y = 5; })
        (leaf "color" "#0007")
      ])

      (plain "struts" [
        (leaf "left" 0)
        (leaf "right" 0)
        (leaf "top" 0)
        (leaf "bottom" 0)
      ])
    ])

    (plain "overview" [
      (plain "workspace-shadow" [
        (flag "off")
      ])
    ])

    # Processes to spawn at startup.
    (leaf "spawn-at-startup" [ "fcitx5" "-d" ])
    (leaf "spawn-at-startup" [ "xrdb" "-merge" ".Xresources" ])
    (leaf "spawn-at-startup" "noctalia")

    (plain "hotkey-overlay" [ ])

    (leaf "screenshot-path" "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.jpg")

    (plain "animations" [ ])

    # Window rule set for noctalia-shell: rounded corners.
    (plain "window-rule" [
      (leaf "clip-to-geometry" true)
    ])

    # Open the Firefox picture-in-picture player as floating by default.
    (plain "window-rule" [
      (leaf "match" {
        app-id = "firefox$";
        title = "^Picture-in-Picture$";
      })
      (leaf "open-floating" true)
    ])

    (plain "debug" [
      # Allows notification actions and window activation from Noctalia.
      (flag "honor-xdg-activation-with-invalid-serial")
    ])

    (plain "binds" [
      # Mod-Shift-/ shows a list of important hotkeys.
      (plain "Mod+Shift+Slash" [ (flag "show-hotkey-overlay") ])

      # Launching programs.
      (node "Mod+T" { hotkey-overlay-title = "Open a Terminal: kitty"; } [ (leaf "spawn" "kitty") ])
      (node "Mod+Shift+T" { hotkey-overlay-title = "Open Telegram Desktop"; } [ (leaf "spawn" "Telegram") ])
      (node "Mod+D" { hotkey-overlay-title = "Run an Application: fuzzel"; } [ (leaf "spawn" "fuzzel") ])
      (node "Super+Alt+L" { hotkey-overlay-title = "Lock the Screen: swaylock"; } [ (leaf "spawn" "swaylock") ])
      (node "Super+Alt+S" {
        allow-when-locked = true;
        hotkey-overlay-title = null;
      } [ (leaf "spawn-sh" "pkill orca || exec orca") ])

      # Core Noctalia binds.
      (plain "Mod+Space" [ (leaf "spawn-sh" "noctalia-shell ipc call launcher toggle") ])
      (plain "Mod+S" [ (leaf "spawn-sh" "noctalia-shell ipc call controlCenter toggle") ])
      (plain "Mod+Shift+M" [ (leaf "spawn-sh" "noctalia-shell ipc call settings toggle") ])

      # Volume keys for PipeWire & WirePlumber.
      (node "XF86AudioRaiseVolume" { allow-when-locked = true; } [ (leaf "spawn-sh" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0") ])
      (node "XF86AudioLowerVolume" { allow-when-locked = true; } [ (leaf "spawn-sh" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-") ])
      (node "XF86AudioMute" { allow-when-locked = true; } [ (leaf "spawn-sh" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") ])
      (node "XF86AudioMicMute" { allow-when-locked = true; } [ (leaf "spawn-sh" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") ])

      # Media keys using playerctl.
      (node "XF86AudioPlay" { allow-when-locked = true; } [ (leaf "spawn-sh" "playerctl play-pause") ])
      (node "XF86AudioStop" { allow-when-locked = true; } [ (leaf "spawn-sh" "playerctl stop") ])
      (node "XF86AudioPrev" { allow-when-locked = true; } [ (leaf "spawn-sh" "playerctl previous") ])
      (node "XF86AudioNext" { allow-when-locked = true; } [ (leaf "spawn-sh" "playerctl next") ])

      # Brightness keys.
      (node "XF86MonBrightnessUp" { allow-when-locked = true; } [ (leaf "spawn" [ "brightnessctl" "--class=backlight" "set" "+10%" ]) ])
      (node "XF86MonBrightnessDown" { allow-when-locked = true; } [ (leaf "spawn" [ "brightnessctl" "--class=backlight" "set" "10%-" ]) ])

      # Overview and closing windows.
      (node "Mod+O" { repeat = false; } [ (flag "toggle-overview") ])
      (node "Mod+Q" { repeat = false; } [ (flag "close-window") ])

      # Focus.
      (plain "Mod+Left" [ (flag "focus-column-left") ])
      (plain "Mod+Down" [ (flag "focus-window-down") ])
      (plain "Mod+Up" [ (flag "focus-window-up") ])
      (plain "Mod+Right" [ (flag "focus-column-right") ])
      (plain "Mod+H" [ (flag "focus-column-left") ])
      (plain "Mod+J" [ (flag "focus-window-down") ])
      (plain "Mod+K" [ (flag "focus-window-up") ])
      (plain "Mod+L" [ (flag "focus-column-right") ])

      # Move windows.
      (plain "Mod+Ctrl+Left" [ (flag "move-column-left") ])
      (plain "Mod+Ctrl+Down" [ (flag "move-window-down") ])
      (plain "Mod+Ctrl+Up" [ (flag "move-window-up") ])
      (plain "Mod+Ctrl+Right" [ (flag "move-column-right") ])
      (plain "Mod+Ctrl+H" [ (flag "move-column-left") ])
      (plain "Mod+Ctrl+J" [ (flag "move-window-down") ])
      (plain "Mod+Ctrl+K" [ (flag "move-window-up") ])
      (plain "Mod+Ctrl+L" [ (flag "move-column-right") ])

      (plain "Mod+Home" [ (flag "focus-column-first") ])
      (plain "Mod+End" [ (flag "focus-column-last") ])
      (plain "Mod+Ctrl+Home" [ (flag "move-column-to-first") ])
      (plain "Mod+Ctrl+End" [ (flag "move-column-to-last") ])

      # Focus monitors.
      (plain "Mod+Shift+Left" [ (flag "focus-monitor-left") ])
      (plain "Mod+Shift+Down" [ (flag "focus-monitor-down") ])
      (plain "Mod+Shift+Up" [ (flag "focus-monitor-up") ])
      (plain "Mod+Shift+Right" [ (flag "focus-monitor-right") ])
      (plain "Mod+Shift+H" [ (flag "focus-monitor-left") ])
      (plain "Mod+Shift+J" [ (flag "focus-monitor-down") ])
      (plain "Mod+Shift+K" [ (flag "focus-monitor-up") ])
      (plain "Mod+Shift+L" [ (flag "focus-monitor-right") ])

      # Move columns to monitors.
      (plain "Mod+Shift+Ctrl+Left" [ (flag "move-column-to-monitor-left") ])
      (plain "Mod+Shift+Ctrl+Down" [ (flag "move-column-to-monitor-down") ])
      (plain "Mod+Shift+Ctrl+Up" [ (flag "move-column-to-monitor-up") ])
      (plain "Mod+Shift+Ctrl+Right" [ (flag "move-column-to-monitor-right") ])
      (plain "Mod+Shift+Ctrl+H" [ (flag "move-column-to-monitor-left") ])
      (plain "Mod+Shift+Ctrl+J" [ (flag "move-column-to-monitor-down") ])
      (plain "Mod+Shift+Ctrl+K" [ (flag "move-column-to-monitor-up") ])
      (plain "Mod+Shift+Ctrl+L" [ (flag "move-column-to-monitor-right") ])

      # Workspaces.
      (plain "Mod+Page_Down" [ (flag "focus-workspace-down") ])
      (plain "Mod+Page_Up" [ (flag "focus-workspace-up") ])
      (plain "Mod+U" [ (flag "focus-workspace-down") ])
      (plain "Mod+I" [ (flag "focus-workspace-up") ])
      (plain "Mod+Ctrl+Page_Down" [ (flag "move-column-to-workspace-down") ])
      (plain "Mod+Ctrl+Page_Up" [ (flag "move-column-to-workspace-up") ])
      (plain "Mod+Ctrl+U" [ (flag "move-column-to-workspace-down") ])
      (plain "Mod+Ctrl+I" [ (flag "move-column-to-workspace-up") ])
      (plain "Mod+Shift+Page_Down" [ (flag "move-workspace-down") ])
      (plain "Mod+Shift+Page_Up" [ (flag "move-workspace-up") ])
      (plain "Mod+Shift+U" [ (flag "move-workspace-down") ])
      (plain "Mod+Shift+I" [ (flag "move-workspace-up") ])

      # Mouse wheel binds with a cooldown.
      (node "Mod+WheelScrollDown" { cooldown-ms = 150; } [ (flag "focus-workspace-down") ])
      (node "Mod+WheelScrollUp" { cooldown-ms = 150; } [ (flag "focus-workspace-up") ])
      (node "Mod+Ctrl+WheelScrollDown" { cooldown-ms = 150; } [ (flag "move-column-to-workspace-down") ])
      (node "Mod+Ctrl+WheelScrollUp" { cooldown-ms = 150; } [ (flag "move-column-to-workspace-up") ])

      (plain "Mod+WheelScrollRight" [ (flag "focus-column-right") ])
      (plain "Mod+WheelScrollLeft" [ (flag "focus-column-left") ])
      (plain "Mod+Ctrl+WheelScrollRight" [ (flag "move-column-right") ])
      (plain "Mod+Ctrl+WheelScrollLeft" [ (flag "move-column-left") ])

      # Shift+scroll replicates horizontal scrolling.
      (plain "Mod+Shift+WheelScrollDown" [ (flag "focus-column-right") ])
      (plain "Mod+Shift+WheelScrollUp" [ (flag "focus-column-left") ])
      (plain "Mod+Ctrl+Shift+WheelScrollDown" [ (flag "move-column-right") ])
      (plain "Mod+Ctrl+Shift+WheelScrollUp" [ (flag "move-column-left") ])

      # Workspaces by index.
      (plain "Mod+1" [ (leaf "focus-workspace" 1) ])
      (plain "Mod+2" [ (leaf "focus-workspace" 2) ])
      (plain "Mod+3" [ (leaf "focus-workspace" 3) ])
      (plain "Mod+4" [ (leaf "focus-workspace" 4) ])
      (plain "Mod+5" [ (leaf "focus-workspace" 5) ])
      (plain "Mod+6" [ (leaf "focus-workspace" 6) ])
      (plain "Mod+7" [ (leaf "focus-workspace" 7) ])
      (plain "Mod+8" [ (leaf "focus-workspace" 8) ])
      (plain "Mod+9" [ (leaf "focus-workspace" 9) ])
      (plain "Mod+Ctrl+1" [ (leaf "move-column-to-workspace" 1) ])
      (plain "Mod+Ctrl+2" [ (leaf "move-column-to-workspace" 2) ])
      (plain "Mod+Ctrl+3" [ (leaf "move-column-to-workspace" 3) ])
      (plain "Mod+Ctrl+4" [ (leaf "move-column-to-workspace" 4) ])
      (plain "Mod+Ctrl+5" [ (leaf "move-column-to-workspace" 5) ])
      (plain "Mod+Ctrl+6" [ (leaf "move-column-to-workspace" 6) ])
      (plain "Mod+Ctrl+7" [ (leaf "move-column-to-workspace" 7) ])
      (plain "Mod+Ctrl+8" [ (leaf "move-column-to-workspace" 8) ])
      (plain "Mod+Ctrl+9" [ (leaf "move-column-to-workspace" 9) ])

      # Move windows in and out of columns.
      (plain "Mod+BracketLeft" [ (flag "consume-or-expel-window-left") ])
      (plain "Mod+BracketRight" [ (flag "consume-or-expel-window-right") ])
      (plain "Mod+Comma" [ (flag "consume-window-into-column") ])
      (plain "Mod+Period" [ (flag "expel-window-from-column") ])

      # Column and window size presets.
      (plain "Mod+R" [ (flag "switch-preset-column-width") ])
      (plain "Mod+Shift+R" [ (flag "switch-preset-window-height") ])
      (plain "Mod+Ctrl+R" [ (flag "reset-window-height") ])
      (plain "Mod+F" [ (flag "maximize-column") ])
      (plain "Mod+Ctrl+F" [ (flag "expand-column-to-available-width") ])

      (plain "Mod+C" [ (flag "center-column") ])
      (plain "Mod+Ctrl+C" [ (flag "center-visible-columns") ])

      # Finer width and height adjustments.
      (plain "Mod+Minus" [ (leaf "set-column-width" "-10%") ])
      (plain "Mod+Equal" [ (leaf "set-column-width" "+10%") ])
      (plain "Mod+Shift+Minus" [ (leaf "set-window-height" "-10%") ])
      (plain "Mod+Shift+Equal" [ (leaf "set-window-height" "+10%") ])

      # Floating windows and tabbed columns.
      (plain "Mod+V" [ (flag "toggle-window-floating") ])
      (plain "Mod+Shift+V" [ (flag "switch-focus-between-floating-and-tiling") ])
      (plain "Mod+W" [ (flag "toggle-column-tabbed-display") ])

      # Screenshots.
      (plain "Print" [ (flag "screenshot") ])
      (plain "Ctrl+Print" [ (flag "screenshot-screen") ])
      (plain "Alt+Print" [ (flag "screenshot-window") ])

      # Escape hatch for keyboard shortcut inhibitors.
      (node "Mod+Escape" { allow-inhibiting = false; } [ (flag "toggle-keyboard-shortcuts-inhibit") ])

      # Quitting and power.
      (plain "Mod+Shift+E" [ (flag "quit") ])
      (plain "Ctrl+Alt+Delete" [ (flag "quit") ])
      (plain "Mod+Shift+P" [ (flag "power-off-monitors") ])
    ])
  ]);

  environment.etc."niri/config.kdl" = lib.mkIf (config.programs.niri.finalConfig != null) {
    source = inputs.niri.lib.internal.validated-config-for pkgs config.programs.niri.package config.programs.niri.finalConfig;
  };
}

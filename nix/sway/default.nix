{ config, pkgs, lib, ... }:
{
  environment.etc = {
    "sway/config".text = (
      with pkgs;
      with config.services.xserver;
      with config.services.xserver.libinput; ''
          input * xkb_layout "${layout}"
          input * xkb_options "${xkbOptions}"
          input * xkb_variant "${xkbVariant}"

          input "type:touchpad" {
            natural_scroll ${if naturalScrolling then "enabled" else "disabled"}
            tap ${if tapping then "enabled" else "disabled"}
          }
        ${builtins.readFile ./config}
          bar {
              position bottom
              status_command i3status-rs ${./i3-status-rust.toml}

              colors {
                  statusline #ffffff
                  background #323232
                  inactive_workspace #32323200 #32323200 #5c5c5c
              }
          }
      ''
    );
  };

  # Here we but a shell script into path, which lets us start sway.service (after importing the environment of the login shell).
  environment.systemPackages = with pkgs; [
    (
      pkgs.writeTextFile {
        name = "startsway";
        destination = "/bin/startsway";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/bash

          # first import environment variables from the login manager
          systemctl --user import-environment
          # then start the service
          exec systemctl --user start sway.service
        '';
      }
    )
  ];

  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.sway = {
    description = "Sway - Wayland window manager";
    documentation = [ "man:sway(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startsway
    environment.PATH = lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
      '';
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.redshift = {
    enable = true;
    # Redshift with wayland support isn't present in nixos-19.09 atm. You have to cherry-pick the commit from https://github.com/NixOS/nixpkgs/pull/68285 to do that.
    package = pkgs.redshift-wlr;
  };

  # Enable sway window manager.
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    extraPackages = with pkgs; [
      swaylock
      swayidle
      xwayland
      mako
      i3status-rust
      dmenu-wayland
    ];
    extraOptions = [ "-c" "/etc/sway/config" ];
  };

  services.dbus.socketActivated = true;
}

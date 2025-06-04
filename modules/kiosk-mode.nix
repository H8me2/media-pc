{ config, lib, pkgs, ... }:

let
  kiosk = config.my.kioskMode;
  autostartScript = ''
    #!/bin/sh
    if [ "$HYPRLAND_KIOSK" = "1" ]; then
      brave --start-fullscreen https://www.youtube.com
    fi
  '';
in {
  config = lib.mkIf kiosk {
    systemd.user.services.kiosk-brave = {
      description = "Launch Brave in Kiosk Mode";
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.writeShellScript "kiosk-start" autostartScript}";
        Restart = "always";
      };
    };

    environment.variables = {
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
    };

    environment.etc."hypr/wallpaper.png".source = pkgs.fetchurl {
      url = "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?auto=format&fit=crop&w=1920&q=80";
      sha256 = "0v8kdw48h29zcbvd3n7rfgb72y0hdmsv6a8p4mvsbw55szpjcdzr";
    };

    home.file.".config/hypr/hyprland.conf".text = ''
      exec = swaybg -i /etc/hypr/wallpaper.png -m fill
    '';
  };
}

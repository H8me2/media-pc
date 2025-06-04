{ config, pkgs, lib, ... }:

let
  inherit (config.my) kioskMode;
in {
  imports = [];

  my.kioskMode = true;

  networking.hostName = "media-pc";
  time.timeZone = "America/New_York";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  users.users.media = {
    isNormalUser = true;
    description = "Media User";
    extraGroups = [ "wheel" "networkmanager" ];
    password = "";
  };

  services.getty.autoLogin.enable = true;
  services.getty.autoLogin.user = "media";

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = false;
  };

  environment.systemPackages = with pkgs; [
    brave
    mpv
    pavucontrol
    thunar
    xfce.thunar-volman
    xfce.tumbler
    gvfs
    gnome.gnome-keyring
    gnome.seahorse
    alacritty
    git
    curl
    wget
    vim
    xdg-utils
    xdg-user-dirs
    file
  ];

  fileSystems."/mnt/nas" = {
    device = "//192.168.1.100/media";
    fsType = "cifs";
    options = [ "username=guest" "password=" "uid=1000" "gid=100" "rw" "x-systemd.automount" "x-systemd.device-timeout=10" "noauto" ];
  };

  environment.variables = lib.mkIf kioskMode {
    HYPRLAND_KIOSK = "1";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.05";
}

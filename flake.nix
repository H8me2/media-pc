{
  description = "Flake-based NixOS config for MinisForum EM680 Media PC";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, flake-utils, hyprland }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        packages.default = pkgs.hello;
      }) // {
    nixosConfigurations.media-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/media-pc/configuration.nix
        ./hosts/media-pc/hardware-configuration.nix
        ./modules/kiosk-mode.nix
        hyprland.nixosModules.default
      ];
    };
  };
}

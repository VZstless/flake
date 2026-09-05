{
  inputs = {
    # firefox in nixpkgs always has a lower version so use flake-firefox-nightly instead
    firefox.url = "github:nix-community/flake-firefox-nightly";

    # nh, yet another nix helper
    nh.url = "github:nix-community/nh";

    # niri as a window manager
    niri.url = "github:sodiboo/niri-flake";

    # lsp for nix
    nixd.url = "github:nix-community/nixd";

    # nixpkgs url
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # nixvim, a neovim configured using nix
    nixvim.url = "github:nix-community/nixvim";

    # nix-on-droid, only for Tweedeldee.
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # noctalia-shell for niri
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs"; # this line is optional, prevents downloading two versions of nixpkgs but disables cache
    };

    # Nix User Repo
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-on-droid, ... }:

    let
      lib = nixpkgs.lib;
      osModules = import ./modules { inherit lib; };
    in {
      nixosConfigurations.Aineias = nixpkgs.lib.nixosSystem {
      
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
          inherit osModules;
        };

        modules = [
          ./hosts/Aineias
          {
            nixpkgs.overlays = [
              inputs.niri.overlays.niri
              inputs.nixd.overlays.default
              inputs.nur.overlays.default
            ];
          }
          {
            nix.settings.trusted-users = [ "vzstless" ];
          }
        ];
      };
      
      # Tweedeldee, nix-on-droid on Samsung Galaxy s10e
      nixOnDroidConfigurations.Tweedeldee = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs { system = "aarch64-linux"; };
        modules = [
          ./hosts/Tweedeldee
        ];
      };
    };
}


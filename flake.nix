{
  inputs = {
    # firefox in nixpkgs always has a lower version so use flake-firefox-nightly instead
    firefox.url = "github:nix-community/flake-firefox-nightly";

    # lsp for nix
    nixd.url = "github:nix-community/nixd";

    # nixpkgs url
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # nixvim, a neovim configured using nix
    nixvim.url = "github:nix-community/nixvim";
    
    # Nix User Repo
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nur, nixd, ... }:

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
              nur.overlays.default
              nixd.overlays.default
            ];
          }
          {
            nix.settings.trusted-users = [ "vzstless" ];
          }
        ];
      };
    };
}


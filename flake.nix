{
  inputs = {
    # firefox in nixpkgs always has a lower version so use flake-firefox-nightly instead
    firefox.url = "github:nix-community/flake-firefox-nightly";

    # nixpkgs and Nix User Repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nur, ... }: {

    nixosConfigurations.Aineias = nixpkgs.lib.nixosSystem {
      
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./hosts/Aineias
        {
          nixpkgs.overlays = [
            nur.overlays.default
          ];
        }
        {
          nix.settings.trusted-users = [ "vzstless" ];
        }
      ];
    };
  };
}


{
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can change the word unstable to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    
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
    # NOTE: 'nixos' is the default hostname
    nixosConfigurations.Aineias = nixpkgs.lib.nixosSystem {
      
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix
        ./system-packages.nix
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


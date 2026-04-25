{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      username = "che";

      mkHost =
        { hostname, profile }:
        lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit hostname;
            inherit profile;
          };

          modules = [
            home-manager.nixosModules.home-manager
            ./config
            ./hosts/${hostname}/hardware.nix
            ./hosts/${hostname}/configuration.nix
            ./profiles/${profile}/configuration.nix
          ];
        };
    in
    {
      packages = import ./pkgs nixpkgs.legacyPackages.${system};
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        vms-test = mkHost {
          hostname = "vms-test";
          profile = "workstation";
        };
      };
    };
}

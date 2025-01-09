{
  description = "Home Manager configuration of nicolas";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    darwin,
    home-manager,
    ...
  }: {
    darwinConfigurations = {
      "macbook" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [./hosts/darwin/macbook.nix];
      };
    };

    nixosConfigurations = {
      "vmware" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [./hosts/nixos/vmware.nix];
      };
    };

    homeConfigurations = {
      "nicolas@macbook" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."aarch64-darwin";
        modules = [./home.nix];
      };

      "nicolas@vmware" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."aarch64-linux";
        modules = [./home.nix];
      };
    };
  };
}

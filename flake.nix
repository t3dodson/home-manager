{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      #url = "git+file:./../../code/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    identity = {
      url = ./identity.nix;
      flake = false;
    };
  };
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ ... }: {
      imports = [ inputs.home-manager.flakeModules.home-manager ];
      systems =
        [ "aarch64-linux" "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
      perSystem = { pkgs, system, ... }:
        let
          home-manager = inputs.home-manager;
          stylix = inputs.stylix;
          identity = import inputs.identity;
          inherit (identity) username;
        in {
          legacyPackages.homeConfigurations.${username} =
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [ stylix.homeModules.stylix ./home.nix ];
              extraSpecialArgs = {
                inherit identity;
                inherit system;
              };
            };
        };
    });
}

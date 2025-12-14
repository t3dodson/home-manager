{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      #url = "git+file:./../../code/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    fenix.url = "github:nix-community/fenix";
    stylix = {
      url = "github:nix-community/stylix";
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
          fenix = inputs.fenix;
          inherit (identity) username;
        in {
          legacyPackages.homeConfigurations.${username} =
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [ stylix.homeModules.stylix ./home.nix ];
              extraSpecialArgs = {
                inherit identity;
                inherit system;
                fenixPkgs = fenix.packages.${system};
              };
            };
        };
    });
  /* outputs = inputs@{ flake-parts, ... }:
     flake-parts.lib.mkFlake { inherit inputs; }
     ({ config, withSystem, moduleWithSystem, ... }: {
       imports = [ inputs.home-manager.flakeModules.home-manager ];
       systems = [ "x86_64-linux" ];
       flake = let
         inherit (inputs) nixpkgs home-manager fenix stylix;
         system = "x86_64-linux";
         pkgs = nixpkgs.legacyPackages.${system};
         identity = if builtins.pathExists ./identity.nix then
           import ./identity.nix { }
         else
           throw "./identity.nix needs to bootstrap";
         inherit (identity) username;
       in {

         homeConfigurations.${username} =
           home-manager.lib.homeManagerConfiguration {
             inherit pkgs;
             modules = [ stylix.homeModules.stylix ./home.nix ];
             extraSpecialArgs = {
               fenixPkgs = fenix.packages.${system};
               inherit identity;
             };
           };
       };
     });
  */
}

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      fenix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      identity =
        if builtins.pathExists ./identity.nix then
          import ./identity.nix { }
        else
          throw "./identity.nix needs to bootstrap";
      inherit (identity) username;
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ./vcs.nix
          ./prompt.nix
          ./editor.nix
          ./shell.nix
          ./ssh.nix
          ./tmux.nix
          ./utils.nix
          ./rust.nix
          ./python.nix
        ];
        extraSpecialArgs = {
          fenixPkgs = fenix.packages.${system};
          inherit identity;
        };
      };
    };
}

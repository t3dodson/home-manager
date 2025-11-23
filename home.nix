{ identity, ... }:
{
  home = {
    inherit (identity)
      username
      homeDirectory
      ;
  };

  home.preferXdgDirectories = true;
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}

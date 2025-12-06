{ identity, stylix, pkgs, ... }: {
  home = { inherit (identity) username homeDirectory; };
  imports = [ ./modules ];
  home.preferXdgDirectories = true;
  home.stateVersion = "25.11";
  stylix.enableReleaseChecks = false;
  stylix.enable = true;
  stylix.base16Scheme =
    "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  programs.home-manager.enable = true;
}

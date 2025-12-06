{ identity, pkgs, ... }: {
  home = { inherit (identity) username homeDirectory; };
  imports = [ ./modules ];
  home.preferXdgDirectories = true;
  home.stateVersion = "25.11";

  # Not sure how dconf got here. I think it may be stylix adding themees to gtk etc...
  dconf.enable = false;

  stylix.enableReleaseChecks = false;
  stylix.enable = true;
  stylix.base16Scheme =
    "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  programs.home-manager.enable = true;
}

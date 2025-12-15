{ identity, pkgs, config, ... }: {
  home = { inherit (identity) username homeDirectory; };
  imports = [ ./modules ];
  home.preferXdgDirectories = true;
  home.stateVersion = "25.11";
  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  # Not sure how dconf got here. I think it may be stylix adding themees to gtk etc...
  dconf.enable = false;

  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    defaultFonts = {
      emoji = [ "Fira Code" ];
      monospace = [ "Fira Code" ];
      sansSerif = [ "Fira Code" ];
      serif = [ "Fira Code" ];
    };
  };
  home.packages = [ pkgs.nerd-fonts.fira-code ];

  stylix.enableReleaseChecks = false;
  stylix.enable = true;
  stylix.base16Scheme =
    "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  programs.home-manager.enable = true;
}

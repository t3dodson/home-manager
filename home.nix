{ identity, pkgs, config, ... }: {
  home = { inherit (identity) username homeDirectory; };
  imports = [ ./modules ];
  home.preferXdgDirectories = true;
  home.stateVersion = "25.11";
  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  # Not sure how dconf got here. I think it may be stylix adding themees to gtk etc...
  dconf.enable = false;

  # TODO difftastic, mergiraf

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

  stylix.enable = true;
  stylix.base16Scheme =
    "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  # Plasma's kde-gtk-config rewrites ~/.gtkrc-2.0 right after stylix applies
  # the look-and-feel, so let KDE own that path and keep home-manager's GTK2
  # config in XDG (GTK2_RC_FILES points apps here).
  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

  programs.home-manager.enable = true;
}

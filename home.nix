{ identity, pkgs, config, lib, ... }: 
let
    fs = lib.fileset;
    allNix = fs.fileFilter (file: file.hasExt "nix") ./modules;
    moduleImports = fs.toList allNix;
in {
  home = { inherit (identity) username homeDirectory; };
  imports = moduleImports;
  home.preferXdgDirectories = true;
  home.stateVersion = "25.11";
  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  # Not sure how dconf got here. I think it may be stylix adding themees to gtk etc...
  dconf.enable = false;

  stylix.enableReleaseChecks = false;
  stylix.enable = true;
  stylix.base16Scheme =
    "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  programs.home-manager.enable = true;
}

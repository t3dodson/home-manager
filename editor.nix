{ pkgs, ... }:
{
  home.sessionVariables =
    let
      nvim = "nvim";
    in
    {
      "EDITOR" = nvim;
      "VISUAL" = nvim;
      "MANPAGER" = "${nvim} +Man!";
    };
  home.packages = [
    pkgs.lua51Packages.lua
    pkgs.lua51Packages.luarocks
    pkgs.nixfmt
    pkgs.unzip
    pkgs.wget
  ];

  home.file.".editorconfig" = {
    enable = true;
    source = ./.editorconfig;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}

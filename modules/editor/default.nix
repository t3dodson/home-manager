{ config, pkgs, lib, ... }: {
  stylix.targets.neovim.enable = false;
  home.sessionVariables = let nvim = "nvim";
  in {
    EDITOR = nvim;
    VISUAL = nvim;
    MANPAGER = "${nvim} +Man!";
  };
  home.packages = [
    pkgs.clang
    pkgs.curl
    pkgs.glibc
    pkgs.gnumake
    pkgs.gnutar
    pkgs.gzip
    pkgs.lua51Packages.lua
    pkgs.lua51Packages.luarocks
    pkgs.nixd
    # TODO, better way for dynamically getting latest versions
    pkgs.nodejs_24
    pkgs.tree-sitter
    pkgs.unzip
    pkgs.wget
  ];

  home.file.".editorconfig" = {
    enable = true;
    source = ./.editorconfig;
  };
  home.activation.nvimConfig = let
    git = "${pkgs.git}/bin/git";
    nvimConfigPath = "${config.xdg.configHome}";
  in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    [ -d "${nvimConfigPath}" ] || ${git} clone https://github.com/t3dodson/nvim.git "${nvimConfigPath}"
  '';

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}


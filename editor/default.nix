{ pkgs, lib, ... }: {
  home.sessionVariables = let nvim = "nvim";
  in {
    "EDITOR" = nvim;
    "VISUAL" = nvim;
    "MANPAGER" = "${nvim} +Man!";
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
  home.activation.afterPkgs = let git = "${pkgs.git}/bin/git";
  in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    [ -d "$HOME/.config/nvim" ] || ${git} clone https://github.com/t3dodson/nvim.git "$HOME/.config/nvim"
  '';

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}


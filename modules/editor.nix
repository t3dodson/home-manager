{ config, pkgs, lib, system, ... }: {
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
    pkgs.gnumake
    pkgs.gnutar
    pkgs.gzip
    pkgs.lua51Packages.lua
    pkgs.lua51Packages.luarocks
    pkgs.nixd
    # TODO, better way for dynamically getting latest versions
    #pkgs.nodejs_24
    pkgs.tree-sitter
    pkgs.unzip
    pkgs.wget
  ] ++ lib.optionals (lib.hasSuffix "-linux" system) [ pkgs.glibc ];

  home.file.".editorconfig" = {
    enable = true;
    source = ./.editorconfig;
  };
  # TODO: re-enable idiomatically (track nvim config as a flake input and
  # symlink it via home.file, or `xdg.configFile."nvim".source = fetchgit {...}`).
  # Disabled 2026-05-29: network call (`git clone`) during activation fails at
  # boot before network-online. Guarded by an existence check, but first boot
  # is still fatal.
  /*
  home.activation.nvimConfig = let
    git = "${pkgs.git}/bin/git";
    nvimConfigPath = "${config.xdg.configHome}/nvim";
  in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ -v DRY_RUN ]]; then
      echo "ENSURE NVIM-CONFIG EXISTS"
    elif [[ -d "${nvimConfigPath}" ]]; then
      echo "TMUX-CONFIG already Exists"
    else
      echo "BOOTSTRAPPING NVIM-CONFIG"
      ${git} clone https://github.com/t3dodson/nvim.git "${nvimConfigPath}"
    fi
  '';
  */

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}


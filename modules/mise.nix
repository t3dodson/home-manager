{ config, pkgs, lib, ... }: {
  programs.mise = {
    enable = true;
    globalConfig = {
      tools = {
        node = "latest";
        python = "latest";
        uv = "latest";
        java = "lts";
        rust = "stable";
        cargo-binstall = "latest";
        go = "latest";
      };
      settings = {
        trusted_config_paths = [ "${config.home.homeDirectory}" ];
        # default is 4 parallel downloads
        jobs = 4;

        # _ is never parsed by mise
        # _ = {};
      };
    };
    settings = { color_theme = "catppuccin"; };
  };

  home.activation.miseInstall = let mise = "${pkgs.mise}/bin/mise";
  in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ -v DRY_RUN ]]; then
      echo "ENSURE MISE INSTALLS EXISTS"
    else
      echo "BOOTSTRAPPING MISE INSTALLS"
      ${mise} install
    fi
  '';

}

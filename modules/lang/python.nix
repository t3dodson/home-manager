{ lib, pkgs, ... }: {
  programs.uv.enable = true;
  home.activation.python = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ -v DRY_RUN ]]; then
      echo "ENSURE PYTHON EXISTS"
    else
      echo "BOOTSTRAPPING PYTHON"
      ${pkgs.uv}/bin/uv python install --default
    fi
  '';

}

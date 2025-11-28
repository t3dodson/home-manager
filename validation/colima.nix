{ pkgs, ... }: rec {

  colima-ephemeral = { disk ? 16, memory ? 4, dns1 ? "1.1.1.1", dns2 ? "8.8.8.8"
    , runtime ? "docker", command ? null }:
    let commandText = if builtins.isNull command then "" else "-- ${command}";
    in pkgs.writeShellApplication {
      name = "colima-ephemeral";
      runtimeInputs = [ pkgs.coreutils pkgs.colima pkgs.docker-client ];
      text = ''
        set -euo pipefail
        # docker is available at ${pkgs.docker-client}/bin/docker
        PROFILE="tmp-profile-$(date +%Y%m%d-%H%M)"
        cleanup() {
            echo "Running cleanup"
            colima stop --profile "$PROFILE" || true
            colima delete --profile "$PROFILE" --force || true
        }

        trap 'cleanup' EXIT INT TERM HUP

        colima start \
            --profile "$PROFILE" \
            --activate \
            --disk ${toString disk} \
            --memory ${toString memory} \
            --dns ${dns1} \
            --dns ${dns2} \
            --runtime ${runtime}

        colima ssh --profile "$PROFILE" ${commandText}
      '';
    };
  home-manager-validation-command-default = { interactive }:
    let interactiveCommand = if interactive then "bash" else "";
    in ''
      bash -c '
                        set -euo pipefail
                        mkdir -p $HOME/.config
                        git clone https://github.com/t3dodson/home-manager ~/.config/home-manager
                        cd ~/.config/home-manager
                        nix run nixpkgs#home-manager -- switch
                        ${interactiveCommand}
                      '
    '';
  home-manager-validation-command = { dockerImage
    , command ? home-manager-validation-command-default { inherit interactive; }
    , interactive ? false, ... }:
    let commandText = if builtins.isNull command then "bash" else command;
    in ''
      set -euo pipefail

      docker load < ${dockerImage}

      IMAGE_ID=$(docker images --quiet | head -n1)
      docker run --rm -it "$IMAGE_ID" ${commandText}
    '';
}

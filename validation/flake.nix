{
  description =
    "CI image with multi-user Nix and real user tom (no HM preinstalled)";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Entrypoint:
      #   1) start nix-daemon as root
      #   2) login as tom
      entrypoint = pkgs.writeShellScriptBin "entrypoint" ''
        set -euo pipefail
        export PATH=/bin

        # Start multi-user Nix daemon
        nix-daemon &

        # Login as tom; /etc/profile.d/nix.sh will set NIX_REMOTE + TLS env
        if [ "$#" -eq 0 ]; then
          exec su --login tom
        else
          exec su --login tom -s /bin/bash -c 'exec "$@"' -- bash "$@"
        fi
      '';
      colimaModule = import ./colima.nix { inherit pkgs; };
      colimaScript = colimaModule.colima-ephemeral {
        command = colimaModule.home-manager-validation-command {
          dockerImage = self.packages.${system}.nix-ci;
        };
      };

    in {
      apps.${system}.colima = {
        type = "app";
        program = "${colimaScript}/bin/colima-ephemeral";
      };
      packages.${system} = {
        nix-ci = pkgs.dockerTools.buildImage {
          name = "nix-ci";

          # Root filesystem: basic tools + Nix + CA certs + entrypoint
          copyToRoot = pkgs.buildEnv {
            name = "rootfs";
            paths = [
              pkgs.bashInteractive
              pkgs.coreutils
              pkgs.findutils
              pkgs.gnugrep
              pkgs.gnused
              pkgs.less
              pkgs.git
              pkgs.nix
              pkgs.cacert
              pkgs.shadow
              pkgs.su
              entrypoint
            ];
            pathsToLink = [ "/bin" "/etc/ssl/certs" ];
          };

          runAsRoot = ''
            #!${pkgs.runtimeShell}
            set -euo pipefail

            ${pkgs.dockerTools.shadowSetup}

            # In runAsRoot, before nix.sh
            mkdir -p /etc
            cat >/etc/profile <<'EOF'
              # Minimal /etc/profile for Docker/Nix CI
              export PATH="/bin:/usr/bin"

              export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
              export NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
              if [ -d /etc/profile.d ]; then
                for f in /etc/profile.d/*.sh; do
                  [ -r "$f" ] && . "$f"
                done
              fi
            EOF
            chmod 0644 /etc/profile


            mkdir -p /etc/profile.d
            cat >/etc/profile.d/nix.sh <<'EOF'
              # Nix multi-user env inside Docker CI
              export NIX_REMOTE=daemon

              # Standard Nix user profile (multi-user install)
              # This is where Nix puts "per-user" profiles.
              if [ -n "$USER" ]; then
                export PATH="/nix/var/nix/profiles/per-user/$USER/profile/bin:$PATH"
              fi

              # Also include the legacy ~/.nix-profile for good measure
              export PATH="$HOME/.nix-profile/bin:$PATH"
            EOF
            chmod 0644 /etc/profile.d/nix.sh

            # pam config
            mkdir -p /etc/pam.d \
              && echo "auth sufficient pam_rootok.so" > /etc/pam.d/su \
              && echo "account sufficient pam_permit.so" >> /etc/pam.d/su \
              && echo "session required pam_permit.so" >> /etc/pam.d/su
            # --- multi-user Nix plumbing ---

            if ! getent group nixbld >/dev/null 2>&1; then
              groupadd -r nixbld
            fi

            # Nix build users: nixbld1..8, as members of group nixbld
            for i in $(seq 1 8); do
              if ! id "nixbld$i" >/dev/null 2>&1; then
                useradd \
                  -c "Nix build user $i" \
                  -d /var/empty \
                  -g nixbld \
                  -G nixbld \
                  -M -N -r \
                  -s /sbin/nologin \
                  "nixbld$i" || true
              fi
            done

            mkdir -p /nix/var/nix/profiles/per-user/root
            mkdir -p /nix/var/nix/profiles/per-user/tom
            mkdir -p /nix/var/nix/daemon-socket
            mkdir -p /nix/var/log/nix
            chmod 0755 /nix/var/nix/daemon-socket

            # --- real user 'tom' ---
            if ! id tom >/dev/null 2>&1; then
              useradd -m -s /bin/bash tom
            fi

            # --- /tmp like a normal Unix ---
            mkdir -p /tmp
            chmod 1777 /tmp

            # --- Nix config ---
            mkdir -p /etc/nix
            cat >/etc/nix/nix.conf <<'EOF'
              experimental-features = nix-command flakes
              sandbox = false
              build-users-group = nixbld
            EOF

          '';

          config = {
            User = "root";
            Entrypoint = [ "/bin/entrypoint" ];
            Env = [
              "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
              "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
            ];
          };

        };
        default = self.packages.${system}.nix-ci;
      };
    };
}

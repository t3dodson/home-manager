{ pkgs, config, lib, ... }:
let
  tmuxPlugins = "${config.xdg.dataHome}/tmux/plugins";
  tpm = "${tmuxPlugins}/tpm";
in {
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = false;
    terminal = "tmux-256color";
    escapeTime = 0;
    extraConfig = ''

      set -g mode-keys vi
      set -g renumber-windows on

      # Panes using alt-arrow without prefix
      bind-key -n M-Left select-pane -L
      bind-key -n M-Right select-pane -R
      bind-key -n M-Up select-pane -U
      bind-key -n M-Down select-pane -D

      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Reloaded"

      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'tmux-plugins/tmux-sensible'

      set -g @plugin 'fcsonline/tmux-thumbs'

      run-shell '${tmuxPlugins}/tmux-thumbs/tmux-thumbs.tmux'

      run-shell '${tpm}/tpm'
    '';
    focusEvents = true;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-b";
  };
  home.activation.tmuxTpm = let git = "${pkgs.git}/bin/git";

  in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ -v DRY_RUN ]]; then
      echo "ENSURE TMUX-TPM EXISTS"
    elif [[ -d "${tpm}" ]]; then
      echo "TMUX-TPM Already Exists"
    else
      echo "BOOTSTRAPPING TMUX-TPM"
      mkdir -p "${tmuxPlugins}" &&
      ${git} clone https://github.com/tmux-plugins/tpm.git "${tpm}"
    fi
  '';
}


{ config, ... }:
let
  shellAliases = {
    opencode = "nix run nixpkgs#opencode --";
  };
in {
  home.shell.enableBashIntegration = true;
  home.shell.enableZshIntegration = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      if [[ ${toString config.programs.tmux.enable} == 1 && -n "$PS1" && -z "$TMUX" ]]; then
        tmux attach -t main || tmux new -s main
      fi
    '';
    inherit shellAliases;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-autosuggestions"
      ];
    };
    defaultKeymap = "vicmd";
    dotDir = "${config.xdg.configHome}/zsh";
    envExtra = ''
      # .zshrc envExtra
    '';
    history = {
      append = true;
      expireDuplicatesFirst = true;
      extended = true;
      saveNoDups = true;
      share = true;
    };
    setOptions = [
      "INTERACTIVECOMMENTS"
    ];
    inherit shellAliases;
    syntaxHighlighting = {
      enable = true;
    };
  };
}

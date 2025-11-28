{ config, ... }:
let
  shellAliases = {
    opencode = "nix run nixpkgs#opencode --";
    hms = "home-manager switch";
  };
in {
  home.shell.enableBashIntegration = true;
  home.shell.enableZshIntegration = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      [[ ${
        toString config.programs.tmux.enable
      } == 1 ]] && [[ -t 0 ]] && [[ -t 1 ]] && [[ -z "$TMUX" ]] && { tmux attach -t main || tmux new -s main; }
    '';
    inherit shellAliases;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    antidote = {
      enable = true;
      plugins = [ "zsh-users/zsh-autosuggestions" ];
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
    setOptions = [ "INTERACTIVECOMMENTS" ];
    inherit shellAliases;
    syntaxHighlighting = { enable = true; };
  };
}

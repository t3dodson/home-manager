{ config, ... }:
let
  shellAliases = {
    opencode = "nix run nixpkgs#opencode --";
    hms = "home-manager switch";
  };
  smartAlias = { name, interactive, nonInteractive ? name }: ''
    ${name}() {
      # Smart Alias
      # Check that we are interactivly sending output to the terminal
      if [[ $- == *i* && -t 1 ]]; then
        command ${interactive} "$@"
      else
        command ${nonInteractive} "$@"
      fi
    }
  '';
  smartShellAliases = {
    cat = smartAlias {
      name = "cat";
      interactive = "bat";
    };
    grep = smartAlias {
      name = "grep";
      interactive = "rg";
    };
    ls = smartAlias {
      name = "ls";
      interactive =
        "eza --oneline --grid --long --icons always --color always --group-directories-first --smart-group --header --git --git-repos";
    };
    tree = smartAlias {
      name = "tree";
      interactive = "eza --tree";
    };
  };
  smartShellAliasesInitSnippet =
    builtins.concatStringsSep "\n" (builtins.attrValues smartShellAliases);
in {
  home.shell.enableBashIntegration = true;
  home.shell.enableZshIntegration = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      [[ "${
        toString config.programs.tmux.enable
      }" == "1" ]] && [[ -z "$TMUX" ]] && { tmux attach -t main || tmux new -s main; }
      ${smartShellAliasesInitSnippet}
    '';
    inherit shellAliases;
    # TODO export HISTIGNORE="cd:cd *:exit" cd/pwd/ls/exit for bash
    # export HIST_IGNORE_PATTERN='cd *|exit' for zsh
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

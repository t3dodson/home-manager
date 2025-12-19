{ config, pkgs, ... }:
let
  shellAliases = {
    ff = "fastfetch";
    opencode = "nix run nixpkgs#opencode --";
    hm = "home-manager";
    hme = "cd ${config.xdg.configHome}/home-manager && nvim .";
    hmm = "man home-manager";
    hmmc = "man home-configuration.nix";
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
    find = smartAlias {
      name = "find";
      interactive = "fd";
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
    top = smartAlias {
      name = "top";
      interactive = "btm";
    };
    tree = smartAlias {
      name = "tree";
      interactive = "eza --tree";
    };
  };
  smartShellAliasesInitSnippet =
    builtins.concatStringsSep "\n" (builtins.attrValues smartShellAliases);
  tmuxInit = if config.programs.tmux.enable then
    let tmux = "${pkgs.tmux}/bin/tmux";
    in ''
      [[ -z "$TMUX" ]] && { ${tmux} attach -t main || ${tmux} new -s main; }
    ''
  else
    "";
in {
  home.shell.enableBashIntegration = true;
  home.shell.enableZshIntegration = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      ${smartShellAliasesInitSnippet}
      ${tmuxInit}
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
    #defaultKeymap = "vicmd";
    dotDir = "${config.xdg.configHome}/zsh";
    envExtra = ''
      ${smartShellAliasesInitSnippet}
      ${tmuxInit}
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

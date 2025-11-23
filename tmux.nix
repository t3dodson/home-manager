{ ... }:
{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = false;
    escapeTime = 0;
    extraConfig = ''
      # extra tmux config
    '';
    focusEvents = true;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-b";
  };
}

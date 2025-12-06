{ ... }: {
  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" "*.ignored.*" ];
    settings = { rerere = { enabled = true; }; };
  };
  programs.gh.enable = true;
  programs.jujutsu.enable = true;
  programs.lazygit.enable = true;
  stylix.targets.lazygit.enable = false;
}

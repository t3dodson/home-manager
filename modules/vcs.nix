{ ... }: {
  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" "*.ignored.*" ];
    settings = {
      user = {
        name = "Tom Dodson";
        email = "t3dodson@gmail.com";
      };
      rerere = { enabled = true; };
    };
  };
  programs.gh.enable = true;
  programs.jujutsu.enable = true;
  programs.lazygit.enable = true;
  stylix.targets.lazygit.enable = false;
}

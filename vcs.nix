{ ... }:
{
  programs.git = {
    enable = true;
    ignores = [
      "*~"
      "*.swp"
      "*.ignored.*"
    ];
    settings = {
      # git settings here
    };
  };
  programs.gh.enable = true;
  programs.jujutsu.enable = true;
  programs.lazygit.enable = true;
}

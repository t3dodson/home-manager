{ pkgs, lib, system, ... }: {
  home.packages = [ pkgs.tokei ]
    ++ lib.optionals (lib.hasSuffix "-linux" system) [ pkgs.strace ];
  programs.awscli.enable = true;
  programs.bat.enable = true;
  programs.bottom.enable = true;
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
  programs.eza = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
  };
  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.htop.enable = true;
  programs.jq.enable = true;
  programs.ranger.enable = true;
  programs.ripgrep.enable = true;
  programs.zoxide.enable = true;
}

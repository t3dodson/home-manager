{ ... }:
{
  programs.awscli.enable = true;
  programs.bat.enable = true;
  programs.bottom.enable = true;
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.htop.enable = true;
  programs.jq.enable = true;
  programs.nnn.enable = true;
  programs.ripgrep.enable = true;
  programs.zoxide.enable = true;
}

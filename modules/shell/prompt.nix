{ config, ... }: {
  programs.carapace.enable = true;
  programs.starship = {
    enable = true;
    configPath = "${config.xdg.configHome}/starship/starship.toml";
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      format = "$time$all$character";
      directory = let normal_style = "cyan"; in{
        truncation_length = 8;
        truncate_to_repo = false;
        style = normal_style;
        repo_root_style = normal_style;
        before_repo_root_style = "brown";

      };
      time = {
        disabled = false;
        format = "[$time](brown) ";
      };
    };
  };
}

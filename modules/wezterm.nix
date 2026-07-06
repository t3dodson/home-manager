{ ... }: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local config = wezterm.config_builder()

      -- No title bar or tabs; keep native edge resizing.
      config.window_decorations = "RESIZE"
      config.enable_tab_bar = false

      return config
    '';
  };
}

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- 共通設定
config.color_scheme = 'iceberg-dark'
config.font_size = 13
config.window_background_opacity = 0.9

-- macOS
config.font = wezterm.font("JetBrains Mono")
config.initial_cols = 140
config.initial_rows = 40

-- Finally, return the configuration to wezterm:
return config

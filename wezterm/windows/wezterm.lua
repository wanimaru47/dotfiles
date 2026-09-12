local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- WSL Setting
-- config.default_prog = { "wsl.exe" }
-- config.default_cwd = "/home/wanimaru"
config.default_domain = "WSL:Ubuntu"

-- カラースキームの設定
config.color_scheme = "iceberg-dark"

-- 背景透過
config.window_background_opacity = 0.9

-- ショートカットキー設定
local act = wezterm.action
config.keys = {
	-- Alt(Opt)+Shift+Fでフルスクリーン切り替え
	{
		key = "f",
		mods = "SHIFT|META",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = act.SpawnCommandInNewTab({
			domain = { DomainName = "WSL:Ubuntu" },
			cwd = "/home/wanimaru",
		}),
	},
}

-- フォントの設定
config.font = wezterm.font("Cascadia Code", { weight = "Medium", stretch = "Normal", style = "Normal" })

-- フォントサイズの設定
config.font_size = 13

-- タスクバー無効化
config.window_decorations = "RESIZE"

return config

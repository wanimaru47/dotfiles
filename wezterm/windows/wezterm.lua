local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

-- iceberg-dark
local c = {
	base = "#0f1117",
	surface = "#1e2132",
	border = "#3d425b",
	muted = "#6b7089",
	subtext = "#818596",
	text = "#c6c8d1",
	accent = "#84a0c6",
	green = "#b4be82",
	red = "#e27878",
}

config.default_domain = "WSL:Ubuntu"

config.color_scheme = "iceberg-dark"
config.colors = {
	tab_bar = {
		background = c.base,
	},
	split = c.border,
}

-- JetBrains Mono と Symbols Nerd Font Mono は WezTerm に同梱されているため、Nerd Font を別途入れなくてもアイコンが出る
config.font = wezterm.font_with_fallback({
	{ family = "JetBrains Mono", weight = "Medium" },
	"Symbols Nerd Font Mono",
})
config.font_size = 12.5
config.line_height = 1.1
config.harfbuzz_features = { "calt=1", "liga=1" }

config.window_decorations = "RESIZE"
config.window_padding = { left = 16, right = 16, top = 8, bottom = 12 }
config.window_background_opacity = 0.85
config.win32_system_backdrop = "Acrylic"
config.inactive_pane_hsb = { saturation = 0.7, brightness = 0.6 }

config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 600
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32
config.status_update_interval = 1000

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local index = tostring(tab.tab_index + 1)
	local title = tab.tab_title ~= "" and tab.tab_title or tab.active_pane.title
	title = wezterm.truncate_right(title, max_width - #index - 4)

	if tab.is_active then
		return {
			{ Background = { Color = c.accent } },
			{ Foreground = { Color = c.base } },
			{ Attribute = { Intensity = "Bold" } },
			{ Text = " " .. index .. " " },
			{ Background = { Color = c.surface } },
			{ Foreground = { Color = c.text } },
			{ Text = " " .. title .. " " },
		}
	end
	return {
		{ Background = { Color = c.base } },
		{ Foreground = { Color = c.muted } },
		{ Text = " " .. index .. " " .. title .. " " },
	}
end)

wezterm.on("update-status", function(window, _)
	local cells = {
		{ wezterm.nerdfonts.cod_terminal_linux, window:active_pane():get_domain_name(), c.subtext },
		{ wezterm.nerdfonts.md_clock_outline, wezterm.strftime("%a %m/%d %H:%M"), c.text },
	}
	for _, b in ipairs(wezterm.battery_info()) do
		local icon = b.state == "Charging" and wezterm.nerdfonts.md_battery_charging or wezterm.nerdfonts.md_battery
		local color = b.state_of_charge < 0.2 and c.red or c.green
		table.insert(cells, { icon, string.format("%.0f%%", b.state_of_charge * 100), color })
	end

	local right = {}
	for _, cell in ipairs(cells) do
		table.insert(right, { Foreground = { Color = cell[3] } })
		table.insert(right, { Text = " " .. cell[1] .. " " .. cell[2] .. " " })
	end
	window:set_right_status(wezterm.format(right))
end)

config.keys = {
	{ key = "f", mods = "SHIFT|META", action = act.ToggleFullScreen },
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = act.SpawnCommandInNewTab({
			domain = { DomainName = "WSL:Ubuntu" },
			cwd = "/home/wanimaru",
		}),
	},
}

return config

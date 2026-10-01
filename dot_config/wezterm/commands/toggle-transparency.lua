local wezterm = require('wezterm')

local command = {
	brief = "Toggle terminal transparency",
	icon = "md_circle_opacity",
	action = wezterm.action_callback(function(window)
		local overrides = window:get_config_overrides() or {}
		local colors = overrides.colors or {}

		if
			not overrides.window_background_opacity
			or overrides.window_background_opacity == 1
		then
			overrides.window_background_opacity = 0.75
			colors.background = 'black'
			overrides.colors = colors
		else
			overrides.window_background_opacity = 1
			colors.background = nil
			overrides.colors = next(colors) and colors or nil
		end

		window:set_config_overrides(overrides)
	end),
}

return command

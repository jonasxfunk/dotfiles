local wezterm = require('wezterm')
local constants = require('constants')

local command = {
	brief = "Toggle terminal theme",
	icon = "md_theme_light_dark",
	action = wezterm.action_callback(function(window)
		local overrides = window:get_config_overrides() or {}

		if overrides.color_scheme == constants.light_color_scheme then
			overrides.color_scheme = nil
		else
			overrides.color_scheme = constants.light_color_scheme
		end

		window:set_config_overrides(overrides)
	end),
}

return command

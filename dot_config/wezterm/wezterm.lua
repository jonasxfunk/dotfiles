local wezterm = require("wezterm")
local commands = require("commands")
local constants = require("constants")
local config = wezterm.config_builder()

-- Tmux image display (Kitty graphics protocol detection for image.nvim/yazi).
-- Not the same as enable_kitty_keyboard (a different, keyboard-input protocol
-- that caused garbage input in new tabs and was removed) — this is graphics-only.
config.term = "xterm-kitty"

-- Font settings
config.font_size = 14
config.line_height = 1.2
config.font = wezterm.font("JetBrainsMono Nerd Font", {
	weight = "Regular",
	stretch = "Normal",
	style = "Normal",
})

-- Apperance
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.default_cursor_style = "SteadyBar"
--config.window_background_opacity = 0.75
--config.macos_window_background_blur = 10
config.color_scheme = constants.dark_color_scheme
--config.window_background_image = constants.bg_image
config.colors = {
	indexed = { [238] = "#7A8478" },
}

-- Bell (no sound, no screen flash)
config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_duration_ms = 0,
	fade_out_duration_ms = 0,
}

-- Miscellaneous settings
config.max_fps = 120
config.use_ime = true
config.window_close_confirmation = "NeverPrompt"
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- Umlauts via Option, regardless of whether the keyboard reports the Option
-- side correctly; all other Alt combos (e.g. Alt-C for fzf) are left untouched
local act = wezterm.action
config.keys = {
	{ key = "o", mods = "ALT", action = act.SendString("ö") },
	{ key = "u", mods = "ALT", action = act.SendString("ü") },
	{ key = "a", mods = "ALT", action = act.SendString("ä") },
	{ key = "s", mods = "ALT", action = act.SendString("ß") },
	{ key = "o", mods = "ALT|SHIFT", action = act.SendString("Ö") },
	{ key = "u", mods = "ALT|SHIFT", action = act.SendString("Ü") },
	{ key = "a", mods = "ALT|SHIFT", action = act.SendString("Ä") },
	{ key = "s", mods = "ALT|SHIFT", action = act.SendString("ẞ") },

	-- Pass Shift+Enter through to terminal apps (e.g. Claude Code) as its own key,
	-- so it can be distinguished from plain Enter (CSI u encoding)
	{ key = "Enter", mods = "SHIFT", action = act.SendString("\x1b[13;2u") },
}

-- Custom Commands
wezterm.on("augment-command-palette", function()
	return commands
end)
return config

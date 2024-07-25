-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = 'Mocha (light) (terminal.sexy)'
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font('Cascadia Code')
config.font_size = 12
config.font_shaper = "Harfbuzz"

config.keys = {
        {
            key = 'F11',
            action = wezterm.action.ToggleFullScreen,
        },
    }

return config

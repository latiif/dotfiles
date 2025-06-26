local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- General appearance
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.window_decorations = "RESIZE"
config.color_scheme = 'Tango (terminal.sexy)'

-- Font settings
config.font = wezterm.font_with_fallback({
  'Cascadia Mono',
  'JetBrains Mono',        -- Fallback
  'Noto Color Emoji',      -- Emoji support
})
config.font_size = 14
config.font_shaper = 'Harfbuzz'

-- Window aesthetics
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.window_background_opacity = 1
config.macos_window_background_blur = 20 -- Only on macOS

-- Cursor appearance
config.cursor_blink_rate = 500

-- Rounded corners (macOS/Linux with Wayland)
config.window_frame = {
  border_left_width = 1,
  border_right_width = 1,
  border_bottom_height = 1,
  border_top_height = 1,
  border_left_color = "#2e3440",
  border_right_color = "#2e3440",
  border_bottom_color = "#2e3440",
  border_top_color = "#2e3440",
}

-- Keybindings
config.keys = {
  {
    key = 'F11',
    action = wezterm.action.ToggleFullScreen,
  },
  {
    key = 'L',
    mods = 'CTRL',
    action = wezterm.action.ShowDebugOverlay,
  },
}

config.adjust_window_size_when_changing_font_size = false
config.freetype_load_target = "Light"

return config

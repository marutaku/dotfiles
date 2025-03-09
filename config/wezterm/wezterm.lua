-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- reload configuration file automatically
config.automatically_reload_config = true

-- exit
config.exit_behavior = 'CloseOnCleanExit'

--[[
  #### Visuals and appearance #### 
]]

-- color scheme
config.color_scheme = "GitHub Dark"

-- font
wezterm.font("HackGen Console NF", {weight="Bold", stretch="Normal", style="Normal"})
config.font_size = 16
config.cell_width = 1.0
config.line_height = 1.0

-- blur
config.window_background_opacity = 0.9
config.macos_window_background_blur = 5

--[[
  #### KeyBind #### 
]]

config.keys = {
  -- ¥ではなく、バックスラッシュを入力する。おそらくMac固有
  {
      key = "¥",
      action = wezterm.action.SendKey { key = '\\' }
  },
  -- cmd w でペインを閉じる（デフォルトではタブが閉じる）
  {
      key = "w",
      mods = "CMD",
      action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- cmd d で右方向にペイン分割
  {
      key = "d",
      mods = "CMD",
      action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } },
  },
  -- cmd Shift d で下方向にペイン分割
  {
      key = "d",
      mods = "CMD|SHIFT",
      action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } },
  },
  -- cmd Ctrl oでペインの中身を入れ替える
  {
      key = "o",
      mods = "CMD|CTRL",
      action = wezterm.action.RotatePanes 'Clockwise'
  },
  -- cmd []でペインの移動 (Prev)
  {
      key = '[',
      mods = 'CMD',
      action = wezterm.action.ActivatePaneDirection 'Prev',
  },
  {
      key = ']',
      mods = 'CMD',
      action = wezterm.action.ActivatePaneDirection 'Next',
  },
  {
    key = 'Enter',
    mods = 'CMD',
    action = wezterm.action.ToggleFullScreen,
  },
}

-- actions
-- notify when the configuration is reloaded
wezterm.on('window-config-reloaded', function(window, pane)
  wezterm.log_info 'the config was reloaded for this window!'
end)

-- and finally, return the configuration to wezterm
return config
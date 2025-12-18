-- App hotkeys using Option (⌥)
local appHotkeys = {
  ['1'] = 'Safari',
  ['2'] = 'Terminal',
  ['3'] = 'Visual Studio Code',
  ['4'] = 'Slack',
}

-- Helper: focus or launch, then maximize
local function focusOrLaunch(appName)
  local app = hs.application.get(appName)
  if app and app:isFrontmost() then
    app:hide()
    return
  end

  if app then
    app:activate()
  else
    hs.application.launchOrFocus(appName)
  end

  -- Wait a short moment for the window to exist, then maximize
  hs.timer.doAfter(0.2, function()
    local newApp = hs.application.get(appName)
    if newApp then
      local win = newApp:mainWindow()
      if win then
        win:maximize()
      end
    end
  end)
end

for key, appName in pairs(appHotkeys) do
  hs.hotkey.bind({'alt'}, key, function()
    focusOrLaunch(appName)
  end)
end

-- Window management hotkeys using Control+Option (⌃⌥)
-- Snap window to right half
hs.hotkey.bind({'ctrl', 'alt'}, 'right', function()
  local win = hs.window.focusedWindow()
  if win then
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
  end
end)

-- Snap window to left half
hs.hotkey.bind({'ctrl', 'alt'}, 'left', function()
  local win = hs.window.focusedWindow()
  if win then
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
  end
end)

-- Maximize window (fill screen)
hs.hotkey.bind({'ctrl', 'alt'}, 'return', function()
  local win = hs.window.focusedWindow()
  if win then
    win:maximize()
  end
end)

-- Debug: Show screen info (Ctrl+Alt+I)
hs.hotkey.bind({'ctrl', 'alt'}, 'i', function()
  local screens = hs.screen.allScreens()
  local info = "Screens found: " .. #screens .. "\n\n"
  for i, screen in ipairs(screens) do
    info = info .. "Screen " .. i .. ":\n"
    info = info .. "  Name: " .. (screen:name() or "nil") .. "\n"
    info = info .. "  ID: " .. screen:id() .. "\n"
    local mode = screen:currentMode()
    info = info .. "  Resolution: " .. mode.w .. "x" .. mode.h .. "\n\n"
  end
  hs.alert.show(info, 10)
  print(info)
end)

-- Move window to built-in screen (filled)
hs.hotkey.bind({'ctrl', 'alt'}, 'down', function()
  local win = hs.window.focusedWindow()
  if win then
    local screens = hs.screen.allScreens()
    -- Sort screens by ID to get consistent ordering
    table.sort(screens, function(a, b) return a:id() < b:id() end)
    -- First screen is typically the built-in
    if screens[1] then
      win:moveToScreen(screens[1])
      win:maximize()
    end
  end
end)

-- Move window to external screen (filled)
hs.hotkey.bind({'ctrl', 'alt'}, 'up', function()
  local win = hs.window.focusedWindow()
  if win then
    local screens = hs.screen.allScreens()
    -- Sort screens by ID to get consistent ordering
    table.sort(screens, function(a, b) return a:id() < b:id() end)
    -- Second screen is typically the external
    if screens[2] then
      win:moveToScreen(screens[2])
      win:maximize()
    end
  end
end)

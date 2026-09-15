-- App hotkeys using Option (⌥)
local appHotkeys = {
  ['1'] = 'Safari',
  ['2'] = 'Ghostty',
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

-- Auto dark/light mode based on ambient light
-- Hysteresis around 450 lux: switch to light above 500, dark below 400,
-- so hovering near the threshold doesn't flip the mode every poll
local ambientLightAbove = 600 -- lux; brighter than this = light mode
local ambientDarkBelow = 200  -- lux; dimmer than this = dark mode

local function setSystemDarkMode(enabled)
  hs.osascript.applescript(string.format([[
    tell application "System Events"
      tell appearance preferences
        set dark mode to %s
      end tell
    end tell
  ]], enabled and "true" or "false"))
end

local currentDarkMode = nil
ambientLightTimer = hs.timer.doEvery(30, function()
  local lux = hs.brightness.ambient()
  if lux < 0 then return end -- no ambient light sensor available

  local wantDark
  if lux < ambientDarkBelow then
    wantDark = true
  elseif lux > ambientLightAbove then
    wantDark = false
  else
    return -- in the 400–500 dead zone: keep current mode
  end

  if wantDark ~= currentDarkMode then
    currentDarkMode = wantDark
    setSystemDarkMode(wantDark)
  end
end)
ambientLightTimer:fire() -- apply immediately on load

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


-- Display layout shortcuts using Control+Option+Shift (⌃⌥⇧)
-- Moves the MacBook display relative to the Dell U2725QE.

local function getDisplays()
  local mac = hs.screen.find("Built%-in")
  local dell = hs.screen.find("DELL U2725QE")

  if not mac or not dell then
    hs.alert.show("Could not find MacBook or Dell display")
    return nil, nil
  end

  return mac, dell
end

local function moveMacBook(direction)
  local mac, dell = getDisplays()
  if not mac or not dell then return end

  local f = dell:fullFrame()

  if direction == "left" then
    mac:setOrigin(f.x - mac:fullFrame().w, f.y)

  elseif direction == "right" then
    mac:setOrigin(f.x + f.w, f.y)

  elseif direction == "below" then
    mac:setOrigin(f.x, f.y + f.h)

  elseif direction == "above" then
    mac:setOrigin(f.x, f.y - mac:fullFrame().h)
  end

  hs.alert.show("MacBook → " .. direction)
end

-- MacBook to the left of Dell
hs.hotkey.bind({'ctrl', 'alt', 'shift'}, 'left', function()
  moveMacBook("left")
end)

-- MacBook to the right of Dell
hs.hotkey.bind({'ctrl', 'alt', 'shift'}, 'right', function()
  moveMacBook("right")
end)

-- MacBook below Dell
hs.hotkey.bind({'ctrl', 'alt', 'shift'}, 'down', function()
  moveMacBook("below")
end)

-- MacBook above Dell
hs.hotkey.bind({'ctrl', 'alt', 'shift'}, 'up', function()
  moveMacBook("above")
end)

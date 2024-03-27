ocal hyper = {"ctrl", "alt", "cmd"}

hs.loadSpoon("MiroWindowsManager")

hs.window.animationDuration = 0.1
spoon.MiroWindowsManager:bindHotkeys({
  up = {hyper, "up"},
  right = {hyper, "right"},
  down = {hyper, "down"},
  left = {hyper, "left"},
  fullscreen = {hyper, "f"},
  nextscreen = {hyper, "n"}
})

local spaces = require("hs.spaces") 

-- Switch alacritty
hs.hotkey.bind({'cmd'}, '`', function ()

  local BUNDLE_ID = 'org.alacritty' -- more accurate to avoid mismatching on browser titles
  function moveWindow(alacritty, space, mainScreen)
    -- move to main space
    local win = nil
    while win == nil do
      win = alacritty:mainWindow()
    end
    print("win="..tostring(win))
    print("space="..tostring(space))
    print("screen="..tostring(win:screen()))
    print("mainScr="..tostring(mainScreen))
    if win:isFullScreen() then
      hs.eventtap.keyStroke('cmd', 'return', 0, alacritty)
    end
    winFrame = win:frame()
    scrFrame = mainScreen:fullFrame()
    winFrame.w = scrFrame.w
    winFrame.y = scrFrame.y
    winFrame.x = scrFrame.x
    print("winFrame="..tostring(winFrame))
    win:setFrame(winFrame, 0)
    print("win:frame=" .. tostring(win:frame()))
    spaces.moveWindowToSpace(win, space)
    if win:isFullScreen() then
      hs.eventtap.keyStroke('cmd', 'return', 0, alacritty)
    end
    win:focus()
  end
  local alacritty = hs.application.get(BUNDLE_ID)
  if alacritty ~= nil and alacritty:isFrontmost() then
    alacritty:hide()
  else
    local space = spaces.activeSpaceOnScreen()
    local mainScreen = hs.screen.mainScreen()
    if alacritty == nil and hs.application.launchOrFocusByBundleID(BUNDLE_ID) then
      local appWatcher = nil
      print('create app watcher')
      appWatcher = hs.application.watcher.new(function(name, event, app)
        print('name='..name)
        print('event='..event)
        if event == hs.application.watcher.launched and app:bundleID() == BUNDLE_ID then
          app:hide()
          moveWindow(app, space, mainScreen)
          print("stop watcher")
          appWatcher:stop()
        end
      end)
      print('start watcher')
      appWatcher:start()
    end
    if alacritty ~= nil then
      moveWindow(alacritty, space, mainScreen)
    end
  end
  
  -- local APP_NAME = 'Alacritty'

  -- -- function moveWindow(alacritty, space)

  -- --   local win = nil
  -- --   while win == nil do
  -- --     win = alacritty:mainWindow()
  -- --   end

  -- --   local res = spaces.moveWindowToSpace(win:id(), space)
  -- --   print(res)
  -- --   alacritty:setFrontmost()
  -- -- end

  -- function moveWindow(alacritty, space)
  --   if not alacritty then return end -- Выход, если объект приложения не существует
    
  --   -- Функция для попытки перемещения окна на заданное пространство
  --   local function tryToMoveWindow(win)
  --     if win then
  --       local res = spaces.moveWindowToSpace(win:id(), space)
  --       print(res)
  --       alacritty:setFrontmost()
  --     else
  --       print("Главное окно не найдено.")
  --     end
  --   end
    
  --   -- Получаем главное окно приложения
  --   local win = alacritty:mainWindow()
  --   if win then
  --     tryToMoveWindow(win)
  --   else
  --     -- Если главное окно не доступно сразу, даем небольшую задержку и пытаемся снова
  --     hs.timer.doAfter(0.5, function() 
  --       win = alacritty:mainWindow() 
  --       tryToMoveWindow(win)
  --     end)
  --   end
  -- end
  

  -- local alacritty = hs.application.get(APP_NAME)
  
  -- -- if alacritty ~= nil and alacritty:isFrontmost() then
  -- --   alacritty:hide()
  -- -- else
  -- if alacritty and hs.application.frontmostApplication() == alacritty then
  --   alacritty:hide()
  -- else
  --   local space = spaces.activeSpaceOnScreen()

  --   if alacritty == nil and hs.application.launchOrFocus(APP_NAME) then
  --     local appWatcher = hs.application.watcher.new(function(name, event, app)
  --       if event == hs.application.watcher.launched and name == APP_NAME then
  --         app:hide()
  --         moveWindow(app, space)
  --         appWatcher:stop()
  --       end
  --     end)
  --     appWatcher:start()
  --   elseif alacritty then
  --     moveWindow(alacritty, space)
  --   end  
  -- end
end)
    
--   else
--     local space = spaces.activeSpaceOnScreen()
--     -- local mainScreen = hs.screen.find(spaces.mainScreenUUID())

--     if alacritty == nil and hs.application.launchOrFocus(APP_NAME) then
--       local appWatcher = nil
--       print('create app watcher')
--       appWatcher = hs.application.watcher.new(function(name, event, app)
--         print(name)
--         print(event)
--         if event == hs.application.watcher.launched and name == APP_NAME then
--           app:hide()
--           moveWindow(app, space) --, mainScreen)
--           appWatcher:stop()
--         end
--       end)
--       print('start watcher')
--       appWatcher:start()
--     end
--     if alacritty ~= nil then
--       moveWindow(alacritty, space) --, mainScreen)
--     end
--   end
-- end)

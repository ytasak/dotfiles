-- Hammerspoon 設定

local function switchToEnglish()
    hs.keycodes.setLayout("ABC")
end

-- Ghostty にフォーカスが移ったら IME を英語に切り替える
appWatcher = hs.application.watcher.new(function(appName, event, appObject)
    if event == hs.application.watcher.activated then
        if appName == "Ghostty" then
            switchToEnglish()
        end
    end
end)
appWatcher:start()

-- Ghostty で Zellij のペイン移動キー (Alt+h/j/k/l) を押したら IME を英語に切り替える
local zellijPaneMoveTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local app = hs.application.frontmostApplication()
    if not app or app:name() ~= "Ghostty" then
        return false
    end

    local flags = event:getFlags()
    if not flags.alt then
        return false
    end

    -- h, j, k, l のキーコード (h=4, j=38, k=40, l=37)
    local keyCode = event:getKeyCode()
    local targetKeyCodes = {[4]=true, [38]=true, [40]=true, [37]=true}
    if targetKeyCodes[keyCode] then
        switchToEnglish()
    end

    return false
end)
zellijPaneMoveTap:start()

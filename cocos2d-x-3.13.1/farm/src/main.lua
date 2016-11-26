
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"

local function main()
	collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    require("app.MyApp"):create():run()
    -- local hello = HelloWorld:create()
    -- local sceneGame = cc.Scene:create()
    -- sceneGame:addChild(hello)
    -- cc.Director:getInstance():runWithScene(sceneGame)

    -- local player = Player:create()
    -- player:Run()
    -- if(1==1) then
    --     return
    -- end
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end

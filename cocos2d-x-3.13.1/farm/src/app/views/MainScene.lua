
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

protobuf = require "protobuf"
local path = cc.FileUtils:getInstance():fullPathForFilename("gs.pb")
protobuf.register_file(path)

function MainScene:onCreate()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)

local addressbook = {
	aa = 2,
	bb = 1,
	cc = "c"
}

local code = protobuf.encode("at", addressbook)
local decode = protobuf.decode("at" , code)

print(decode.aa)
print(decode.cc)

end

return MainScene

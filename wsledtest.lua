local config = require('config')

local colors = {}
local pos = 0
local MAX = 1200
-- angel
-- local MAX = 141
local length = 4

local direction = 1

local function writeColorValues()
    ws2812.write(config.PIN_LEDSTRIP, string.char(0,0,0):rep(pos) ..
        string.char(0, 255, 0, 0, 200, 0, 0, 100, 0, 0, 30, 0) ..
        string.char(0,0,0):rep(MAX-length-pos) .. string.char(0, 200, 0))
    pos = pos + direction
    if pos >= MAX then
        direction = -1
    elseif pos <= 0 then
        direction = 1
    end
end

local function start()
    tmr.alarm(2, 100, 1, writeColorValues)
end

return {start = start}

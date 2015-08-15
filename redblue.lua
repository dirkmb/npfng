local config = require('config')
local i = 1
local colors = {
    {255, 0  , 0  , 100},
    {0  , 0  , 0  , 50},
    {255, 0  , 0  , 100},
    {0  , 0  , 0  , 50},
    {0  , 255, 0, 100},
    {0  , 0  , 0  , 50},
    {0  , 255, 0  , 100},
    {255, 255, 255, 50},
}

local function update_leds()
    ws2812.init_buffer(string.char(colors[i][1],colors[i][2],colors[i][3]):rep(config.LED_STRIP_LENGTH))
    ws2812.write_buffer(config.PIN_LEDSTRIP)
    i = i+1
    if i > table.getn(colors) then
        i = 1
    end
    tmr.alarm(2, colors[i][4], 0, update_leds)
end

local function start()
    update_leds()
end

return {start = start}

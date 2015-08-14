local config = require('config')
local wsled = require('wsled_config')


local MAX_LENGTH = 50

local function writeColorValues()
    if wsled.length > MAX_LENGTH then
        wsled.length = MAX_LENGTH
    end
    if wsled.length <= 0 then
        wsled.length = 1
    end
    color_stripe = string.char(wsled.colorB, wsled.colorR, wsled.colorG):rep(wsled.length)
    --color_stripe = ""
    --for i = 0, length-1 do
    --    color_stripe = color_stripe .. string.char(colorB/(i+0), colorR/(i+1), colorG/(i+1))
    --end

    top = string.char(0,0,0):rep(wsled.length)
    if wsled.mode == 2 then
        wsled.signal_red = wsled.signal_red + wsled.signal_red_change
        if wsled.signal_red >= 255 then
            wsled.signal_red_change = wsled.signal_red_change * -1
            wsled.signal_red = 255
        end
        if wsled.signal_red <= 0 then
            wsled.signal_red_change = wsled.signal_red_change * -1
            wsled.signal_red = 0
        end
        top = string.char(0, wsled.signal_red, 0):rep(wsled.length)
    end

    ws2812.write(config.PIN_LEDSTRIP, string.char(0,0,0):rep(wsled.pos) .. color_stripe .. string.char(0,0,0):rep(config.LED_STRIP_LENGTH-wsled.length-wsled.pos-wsled.length) .. top)

    wsled.pos = wsled.pos + wsled.direction
    if wsled.pos >= config.LED_STRIP_LENGTH then
        wsled.direction = -1
    elseif wsled.pos <= 0 then
        wsled.direction = 1
    end
end

return {writeColorValues = writeColorValues}

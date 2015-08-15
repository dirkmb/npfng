local config = require('config')
local wsled_config = require('wsled_config')


local MAX_LENGTH = 50


local function writeColorValues()
    if wsled_config.length <= 0 then
        wsled_config.length = 1
    end
    color_stripe = string.char(wsled_config.colorB, wsled_config.colorR, wsled_config.colorG):rep(wsled_config.length)
    --color_stripe = ""
    --for i = 0, length-1 do
    --    color_stripe = color_stripe .. string.char(colorB/(i+0), colorR/(i+1), colorG/(i+1))
    --end

    top = string.char(0,0,0):rep(wsled_config.length)
    if wsled_config.mode == 2 then
        wsled_config.signal_red = wsled_config.signal_red + wsled_config.signal_red_change
        if wsled_config.signal_red >= 255 then
            wsled_config.signal_red_change = wsled_config.signal_red_change * -1
            wsled_config.signal_red = 255
        end
        if wsled_config.signal_red <= 0 then
            wsled_config.signal_red_change = wsled_config.signal_red_change * -1
            wsled_config.signal_red = 0
        end
        top = string.char(0, wsled_config.signal_red, 0):rep(wsled_config.length)
    end

    ws2812.write(config.PIN_LEDSTRIP, string.char(0,0,0):rep(wsled_config.pos) .. color_stripe .. string.char(0,0,0):rep(config.LED_STRIP_LENGTH-wsled_config.length-wsled_config.pos-wsled_config.length) .. top)

    wsled_config.pos = wsled_config.pos + wsled_config.direction
    if wsled_config.pos >= config.LED_STRIP_LENGTH then
        wsled_config.direction = -1
    elseif wsled_config.pos <= 0 then
        wsled_config.direction = 1
    end
end


local function led_func_timer()
    writeColorValues()
    tmr.alarm(2, wsled_config.speed, 0, led_func_timer)
end

local function start()
    ws2812.fill_buffer(0, string.char(0,0,0):rep(config.LED_STRIP_LENGTH))
    tmr.alarm(2, wsled_config.speed, 0, led_func_timer)
end

return {start = start}

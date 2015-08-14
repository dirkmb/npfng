local config = require('config')

direction = 1
pos = 0

speed = 300
colorR = 200
colorG = 200
colorB = 200
length = 4

mode = 2

signal_red = 0
signal_red_change = 10

local MAX_LENGTH = 50

local function writeColorValues()
    if speed < 20 then
        speed = 20
    end
    if length > MAX_LENGTH then
        length = MAX_LENGTH
    end
    if length <= 0 then
        length = 1
    end
    color_stripe = string.char(colorB, colorR, colorG):rep(length)
    --color_stripe = ""
    --for i = 0, length-1 do
    --    color_stripe = color_stripe .. string.char(colorB/(i+0), colorR/(i+1), colorG/(i+1))
    --end

    top = string.char(0,0,0):rep(length)
    if mode == 2 then
        signal_red = signal_red + signal_red_change
        if signal_red >= 255 then
            signal_red_change = signal_red_change * -1
            signal_red = 255
        end
        if signal_red <= 0 then
            signal_red_change = signal_red_change * -1
            signal_red = 0
        end
        top = string.char(0, signal_red, 0):rep(length)
    end

    ws2812.write(config.PIN_LEDSTRIP, string.char(0,0,0):rep(pos) .. color_stripe .. string.char(0,0,0):rep(config.LED_STRIP_LENGTH-length-pos-length) .. top)

    pos = pos + direction
    if pos >= config.LED_STRIP_LENGTH then
        direction = -1
    elseif pos <= 0 then
        direction = 1
    end
end

return {writeColorValues = writeColorValues,
    speed = 300}

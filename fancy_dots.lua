local config = require('config')
local wsled_config = require('wsled_config')


local MAX_LENGTH = 50


-- wsled_config.lenght = length of dot
-- wsled_config.dot_count = dot count

local colors = {
    {255, 0  , 0  },
    {0  , 255, 0  },
    {0  , 0  , 255},
    {255, 128, 0  },
    {128, 0  , 255},
    }


local dot_length = 4

local dots = {
    {math.random(config.LED_STRIP_LENGTH), math.random(3), colors[1], string.char(0,0,0):rep(dot_length)},
    {math.random(config.LED_STRIP_LENGTH), -math.random(3), colors[2], string.char(0,0,0):rep(dot_length)},
    {math.random(config.LED_STRIP_LENGTH), math.random(3), colors[3], string.char(0,0,0):rep(dot_length)},
    {math.random(config.LED_STRIP_LENGTH), math.random(3), colors[4], string.char(0,0,0):rep(dot_length)},
    {math.random(config.LED_STRIP_LENGTH), -math.random(3), colors[5], string.char(0,0,0):rep(dot_length)},
    {math.random(config.LED_STRIP_LENGTH), -math.random(3), colors[5], string.char(0,0,0):rep(dot_length)},
}

local function update_fancy_dots()
    --color_stripe = ""
    --for i = 0, length-1 do
    --    color_stripe = color_stripe .. string.char(colorB/(i+0), colorR/(i+1), colorG/(i+1))
    --end
    --
    for id, dot in pairs(dots) do
        -- turn of the old pos
        ws2812.set_leds(dot[1], string.char(0):rep(3*dot_length))
        -- update pos
        dot[1] = dot[1] + dot[2]
        -- draw color
        if dot[1] < 0 then
            dot[1] = 0
            dot[2] = dot[2] * -1
            dot[3] = colors[math.random(5)]
            dot[4] = ""
            for i = 1, dot_length do
                dot[4] = dot[4] .. string.char(dot[3][1]/(2^(dot_length-i+1)), dot[3][2]/(2^(dot_length-i+1)), dot[3][3]/(2^(dot_length-i+1)))
            end
        elseif dot[1] > config.LED_STRIP_LENGTH then
            dot[1] = config.LED_STRIP_LENGTH
            dot[2] = dot[2] * -1
            dot[3] = colors[math.random(5)]
            dot[4] = ""
            for i = 1, dot_length do
                dot[4] = dot[4] .. string.char(dot[3][1]/(2^(i+1)), dot[3][2]/(2^(i+1)), dot[3][3]/(2^(i+1)))
            end
        end
        ws2812.set_leds(dot[1], dot[4])
    end

    -- update values
    ws2812.write_buffer(config.PIN_LEDSTRIP)
end


local function led_func_timer()
    update_fancy_dots()
    tmr.alarm(2, wsled_config.speed, 0, led_func_timer)
end

local function start()
    ws2812.init_buffer(string.char(0,0,0):rep(config.LED_STRIP_LENGTH))
    tmr.alarm(2, wsled_config.speed, 0, led_func_timer)
end

return {start = start}

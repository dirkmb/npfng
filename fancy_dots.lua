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


local dots = {
    {math.random(config.LED_STRIP_LENGTH), math.random(3), colors[1]},
    {math.random(config.LED_STRIP_LENGTH), math.random(3), colors[2]},
    {math.random(config.LED_STRIP_LENGTH), math.random(3), colors[3]},
    {math.random(config.LED_STRIP_LENGTH), -math.random(3), colors[4]},
    {math.random(config.LED_STRIP_LENGTH), -math.random(3), colors[5]},
}

local function update_fancy_dots()
    --color_stripe = ""
    --for i = 0, length-1 do
    --    color_stripe = color_stripe .. string.char(colorB/(i+0), colorR/(i+1), colorG/(i+1))
    --end
    --
    for id, dot in pairs(dots) do
        -- turn of the old pos
        ws2812.set_led(dot[1], 0, 0, 0)
        -- update pos
        dot[1] = dot[1] + dot[2]
        -- draw color
        if dot[1] < 0 then
            dot[1] = 0
            dot[2] = dot[2] * -1
            dot[3] = colors[math.random(5)]
        elseif dot[1] > config.LED_STRIP_LENGTH then
            dot[1] = config.LED_STRIP_LENGTH
            dot[2] = dot[2] * -1
            dot[3] = colors[math.random(5)]
        end
        ws2812.set_led(dot[1], dot[3][1], dot[3][2], dot[3][3])
    end

    -- update values
    ws2812.write_buffer(config.PIN_LEDSTRIP)
end


local function led_func_timer()
    update_fancy_dots()
    tmr.alarm(2, wsled_config.speed, 0, led_func_timer)
end

local function start()
    ws2812.fill_buffer(string.char(0,0,0):rep(config.LED_STRIP_LENGTH))
    tmr.alarm(2, wsled_config.speed, 0, led_func_timer)
end

return {start = start}

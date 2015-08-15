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
    {255, 0  , 128},
    {0  , 255, 128},
    {128, 255, 0  },
    {0  , 128, 255},
    {128, 0  , 255},
    }



local dots = {
--   start position                      , speed         , farbe    , schweif                           , return position
    {math.random(config.LED_STRIP_LENGTH), math.random(3), colors[1], string.char(0,0,0):rep(3), math.random(config.LED_STRIP_LENGTH)},
}

local function update_fancy_dots()
    --color_stripe = ""
    --for i = 0, length-1 do
    --    color_stripe = color_stripe .. string.char(colorB/(i+0), colorR/(i+1), colorG/(i+1))
    --end
    --
    for id, dot in pairs(dots) do
        -- turn of the old pos
        ws2812.set_leds(dot[1], string.char(0):rep(3*math.abs(dot[2])))
    end
    for id, dot in pairs(dots) do
        -- update pos
        dot[1] = dot[1] + dot[2]
        -- draw color
        if dot[1] < 0 then
            dot[1] = 0
            dot[2] = dot[2] * -1
            dot[3] = colors[math.random(5)]
            dot[4] = ""
            for i = 1, math.abs(dot[2]) do
                dot[4] = dot[4] .. string.char(dot[3][1]/(2^(math.abs(dot[2])-i+1)), dot[3][2]/(2^(math.abs(dot[2])-i+1)), dot[3][3]/(2^(math.abs(dot[2])-i+1)))
            end
        elseif dot[1] > config.LED_STRIP_LENGTH then
            dot[1] = config.LED_STRIP_LENGTH
            dot[2] = dot[2] * -1
            dot[3] = colors[math.random(5)]
            dot[4] = ""
            for i = 1, math.abs(dot[2]) do
                dot[4] = dot[4] .. string.char(dot[3][1]/(2^(i+1)), dot[3][2]/(2^(i+1)), dot[3][3]/(2^(i+1)))
            end
        end
        ws2812.add_leds(dot[1], dot[4])
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
    for i = 1, config.LED_STRIP_LENGTH/30  do
        local c = colors[i%9+1]
        local l = math.random(4)
        dots[i] = {math.random(config.LED_STRIP_LENGTH), l*(-1^i), c, string.char(c[1],c[2],c[3]) .. string.char(0,0,0):rep(l), math.random(config.LED_STRIP_LENGTH)}
    end
    tmr.alarm(2, wsled_config.speed, 0, led_func_timer)
end

return {start = start}

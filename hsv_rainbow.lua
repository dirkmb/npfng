local config = require('config')

function hslToRgb(h, s, l, a)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    function hue2rgb(p, q, t)
      if t < 0   then t = t + 1 end
      if t > 1   then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end

    local q
    if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end

  return r * 255, g * 255, b * 255, a * 255
end

local function update_leds()
    local brightness = 0.5
    local saturation = 1
    local step_width = 0.01
    ws2812.init_buffer(string.char(0, 0, 0):rep(config.LED_STRIP_LENGTH))
    for i=1,config.LED_STRIP_LENGTH do
        local r, g, b = hslToRgb(i*step_width, saturation, brightness, 1)
        ws2812.set_led(i, r, g, b)
    end
    ws2812.write_buffer(config.PIN_LEDSTRIP)
    tmr.alarm(2, 1000, 0, update_leds)
end

local function start()
    update_leds()
end

return {start = start}

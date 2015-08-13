local config = require('config')

speed = 100
colorR = 200
colorG = 200
colorB = 200
length = 4

local MAX_LENGTH = 50
pos = 0
local MAX = config.LED_STRIP_LENGTH
direction = 1

mode = 1

local function writeColorValues()
    color_stripe = ""
    for i = 0, length do
        color_stripe  = color_stripe .. string.char(colorB/(i+1), colorR/(i+1), colorG/(i+1))
    end

    top = string.char(0,0,0):rep(length)
    if mode == 2 then
        top = string.char(math.random(255), math.random(255), math.random(255)):rep(length)
    end

    ws2812.write(config.PIN_LEDSTRIP, string.char(0,0,0):rep(pos) .. color_stripe .. string.char(0,0,0):rep(MAX-length-pos-length) .. top)

    pos = pos + direction
    if pos >= MAX then
        direction = -1
    elseif pos <= 0 then
        direction = 1
    end
    if speed < 20 then
        speed = 20
    end
    tmr.alarm(2, speed, 0, writeColorValues)
end

function startServer()
   print("Wifi AP connected. Wicon IP:")
   print(wifi.sta.getip())
   sv=net.createServer(net.TCP, 180)
   sv:listen(8080,   function(conn)
      print("Wifi console connected.")

      function s_output(str)
         if (conn~=nil)    then
            conn:send(str)
         end
      end
      node.output(s_output,0)

      conn:on("receive", function(conn, pl)
         node.input(pl)

         if (conn==nil)    then
            print("conn is nil.")
         end
      end)
      conn:on("disconnection",function(conn)
         node.output(nil)
      end)
   end)
   print("==== Wicon Server running at :8080 ====")
end


local function start()
    tmr.alarm(2, speed, 0, writeColorValues)
    startServer()
end

return {start = start}

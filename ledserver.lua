local config = require('config')

wsled = require('wsled')

function led_func_timer()
    wsled.writeColorValues()
    tmr.alarm(2, wsled.speed, 0, led_func_timer)
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
    tmr.alarm(2, wsled.speed, 0, led_func_timer)
    startServer()
end

return {start = start}

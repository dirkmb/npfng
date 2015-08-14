#!/bin/bash

set -e


for f in 'init', 'pluginloader', 'wificonnect', 'config', 'ledserver', 'wsled'
do
    echo "remove $f"
    echo "file.remove('${f}.lua')" > /dev/ttyUSB0
    sleep .1
    echo "file.remove('${f}.lc')" > /dev/ttyUSB0
    sleep .1
done


./luatool.py -f init.lua
./luatool.py -c -f pluginloader.lua
./luatool.py -f wificonnect.lua
#./luatool.py -f config.lua
./luatool.py -f config_tent.lua -t config.lua
./luatool.py -f ledserver.lua
./luatool.py -f wsled.lua -r

#./luatool.py -c -f telnet.lua
# ./luatool.py -c -f drf_api.lua
# ./luatool.py -f dht_reader.lua

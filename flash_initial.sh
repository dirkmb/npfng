#!/bin/bash

set -e

OLD_PWD=$PWD

cd ../npfng/

./flash_initial.sh

#./luatool.py -f $PWD/config.lua
./luatool.py -f $OLD_PWD/config_tent.lua -t config.lua
./luatool.py -f $OLD_PWD/ledserver.lua
#./luatool.py -f $OLD_PWD/wsled.lua
./luatool.py -f $OLD_PWD/fancy_dots.lua

./luatool.py -f $OLD_PWD/wsled_config.lua -r

#./luatool.py -c -f telnet.lua
# ./luatool.py -c -f drf_api.lua
# ./luatool.py -f dht_reader.lua

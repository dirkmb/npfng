local gpio = {[0]=3,[1]=10,[2]=4,[3]=9,[4]=1,[5]=2,[10]=12,[12]=6,[13]=7,[14]=5,[15]=8,[16]=0}

return {
    DEBUG = false,
    SKIP_WIFI_CONNECT = false,
    WIFI_SSID = 'Camp2015-open-legacy',
    WIFI_KEY = '',

    LED_STRIP_LENGTH = 596,

    PLUGINS = {
        'ledserver',
    },

    PIN_REED_SWITCH = nil,
    PIN_GREEN_LED = nil,
    PIN_RED_LED = nil,
    PIN_RGB_LED = gpio[5],
    PIN_DHT = nil,
    PIN_LEDSTRIP = gpio[13],
}

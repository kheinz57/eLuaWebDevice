print "get new hw-id 3"
id = pd.id()
print(id)

local uartid, invert, ledpin = 0, false
ledpin = pio.PF_0

local server = net.packip(192,168,1,1)
print "1"
local socket = net.socket(net.SOCK_STREAM)
print "2"
local err = net.connect(socket, server, 4712)
print ("connected err=", err)
local res,err = net.send(socket,"start fast blinking\n") 
local res,err = net.send(socket,"done fast blinking\n") 
local res,err = net.send(socket,"redefine print\n") 
print "redefine print"

function newprint(...)
    local printResult = ""
    for i,v in ipairs(arg) do
        printResult = printResult .. tostring(v) .. "\t"
    end
    local res,err = net.send(socket,printResult.."\n")
end
print = newprint

print "hallo via tcp"

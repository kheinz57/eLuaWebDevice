local socket = require("socket")
local os = require("os")

local host = host or "*"
local port = port or 4711
if arg then
	host = arg[1] or host
	port = arg[2] or port
end
print("Binding to host '" ..host.. "' and port " ..port.. "...")
s = assert(socket.bind(host, port))
i, p   = s:getsockname()
assert(i, p)
while true do
    print("Waiting for connection from e2 device on " .. i .. ":" .. p .. "...")
    local c = assert(s:accept())
    print("receiving hw-id from device.. ")
    local data, e = c:receive(8)
    print("DBG: got from device:", data,e)
    if (#data > 0) then
        print("got request from device "..data)
        local filename = "../device/code/"..data..".lua"
--        local file = assert(io.open("../device/code/e2device.lua","r"))
--        local file = assert(io.open("../device/code/e2dev_"..data..".lua","r"))
        local file = io.open(filename,"r")
        if (file == nil) then
            file = io.open(filename, "w")
            file:write("-- new file generated because of request from the device\n print 'new file ist still empty'")
            file:close()
            file = assert(io.open(filename,"r"))
        end
        local content = file:read("*all")
        local filelen=string.format("%05d",#content)
        file:close()
        print ("filelen="..filelen)
        print (content)
        print("Connected. Send len="..filelen)
         os.execute("sleep 1")
       c:send(filelen)
        print("send returned ") 
        os.execute("sleep 1")
        l, e = c:receive(2)
        print("recv returned ") 
        os.execute("sleep 1")
        c:send(content)
        print("send returned ") 
        os.execute("sleep 1")
        l, e = c:receive(2)
        c:close()
    end
end

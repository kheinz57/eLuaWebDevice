local socket = require("socket")
local os = require("os")

local host = host or "*"
local port = port or 4711
if arg then
	host = arg[1] or host
	port = arg[2] or port
end
s = assert(socket.bind(host, port))
i, p   = s:getsockname()
assert(i, p)
while true do
    print("====================================================================")
    print("Waiting for connection from a eLUA device on " .. i .. ":" .. p .. "...")
    local c = assert(s:accept())
    local data, e = c:receive(8)
    if (#data > 0) then
        print("got request from device "..data)
        local filename = "../device/code/"..data..".lua"
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
        print("---------------------------------------------------------------------")
        print (content)
        print("---------------------------------------------------------------------")
        print("Connected. Send len="..filelen)
        os.execute("sleep 1")
        c:send(filelen)
        os.execute("sleep 1")
        l, e = c:receive(2)
        os.execute("sleep 1")
        c:send(content)
        os.execute("sleep 1")
        l, e = c:receive(2)
        c:close()
    end
end

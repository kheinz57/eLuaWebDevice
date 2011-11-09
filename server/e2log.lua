local socket = require("socket")
local os = require("os")

local host = host or "*"
local port = port or 4712
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
    while true do
        local data,err = c:receive()
        if data == nil then break end
        print (data)
    end
    c:close()
end

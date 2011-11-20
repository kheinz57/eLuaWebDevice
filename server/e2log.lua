-- Copyright 2010 Heinz Haeberle
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0

-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
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

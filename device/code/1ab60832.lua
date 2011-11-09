function httpget(ip,port,path)

    local req = "GET " .. path .. 
      " HTTP/1.1\r\nHost: 192.168.1.1\r\nUser-Agent: eLua net\r\n\r\n"

    print "connecting http server"
    local server = net.packip(192,168,1,1)
    local socket = net.socket(net.SOCK_STREAM)
    local err = net.connect(socket, server, 9494)
    if err ~= 0 then
        net.close(socket)
        print "connection failed"
        return {err = "Connection fail"}
    end
--    local res,err = net.send(socket,"GET /code/dev.lua HTTP/1.1\r\n\r\n")
    local res,err = net.send(socket,req)
    if err ~= 0 then
        print "error send"
        net.close(socket)
		return {err = "Request error: " .. tostring( err_send )}
    end
    print "request sent"
                          
    -- Receive
    local contentLength
    while true do
        local line, err_recv = net.recv( socket, 1024 )
        print ("{"..line.."}")
        if string.find(line, "Content-Length:") then
            contentLength = string.match(line, "Content-Length:%s(%d+)")
            print ("contentLength="..contentLength)
        end
        if string.len(line) == 0 then break end
    end
    local response, err_recv = net.recv( socket, 512 )
   
    if err_recv ~= 0 then
        net.close(socket)
        return {err = "Receive error: " .. err_recv}
    else
        local  code = string.match(response, "HTTP/%d*%.%d* (%d%d%d)")
        local headers, body = string.match(response, "^(.+)%\r\n(.+)$")
        net.close(socket)
		collectgarbage("collect")
		return {body = body, code = code, headers = headers}
    end
end

print(1,"\r\n")
local resp = httpget(net.packip(192,168,1,1), 9494, "/code/test.lua")
print("CODE:",resp.code,"\r\n HEADERS:",resp.headers,"\r\n BODY:",resp.body,"\r\n")
print(2,"\r\n")

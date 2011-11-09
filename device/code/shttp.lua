function httpget(host,port,path)

    local req = "GET " .. path .. " HTTP/1.1\r\nHost: " .. host .. "\r\nUser-Agent: eLua net\r\n"

    local ip = net.lookup(host)    
    local sock = net.socket(net.SOCK_STREAM)
    if net.connect(sock, ip, port) ~= 0 then
        net.close(sock)
        return {err = "Connection fail"}
    end

    -- Request
    local sentBytes, err_send = net.send( sock, req )
    if err_send ~= 0 then
        net.close(sock)
		return {err = "Request error: " .. tostring( err_send )}
    end
                          
    -- Receive
    local response, err_recv = net.recv( sock, 512 )
   
    if err_recv ~= 0 then
        net.close(sock)
        return {err = "Receive error: " .. err_recv}
    else
        local  code = string.match(response, "HTTP/%d*%.%d* (%d%d%d)")
        local headers, body = string.match(response, "^(.+)%\r\n(.+)$")
        net.close(sock)
		collectgarbage("collect")
		return {body = body, code = code, headers = headers}
    end
end

print(1,"\r\n")
local resp = httpget("localhost", 9494, "/code/test.lua")
print("CODE:",resp.code,"\r\n HEADERS:",resp.headers,"\r\n BODY:",resp.body,"\r\n")
print(2,"\r\n")

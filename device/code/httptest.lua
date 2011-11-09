-- HTTP/1.1 client support over eLua net module 
-- Inspired in Lua socket.http
-- Vagner Nascimento
-- July 2010

--module("http", package.seeall)

-- support functions
function escape(s)
    return string.gsub(s, "([^A-Za-z0-9_])", function(c)
        return string.format("%%%02x", string.byte(c))
    end)
end

--  local functions
local function parse(url, default)
    -- initialize default parameters
    local parsed = {}
    for i,v in pairs(default or parsed) do parsed[i] = v end
    -- empty url is parsed to nil
    if not url or url == "" then return nil, "invalid url" end
    -- remove whitespace
    -- url = string.gsub(url, "%s", "")
    -- get fragment
    url = string.gsub(url, "#(.*)$", function(f)
        parsed.fragment = f
        return ""
    end)
    -- get scheme
    url = string.gsub(url, "^([%w][%w%+%-%.]*)%:",
        function(s) parsed.scheme = s; return "" end)
    -- get authority
    url = string.gsub(url, "^//([^/]*)", function(n)
        parsed.authority = n
        return ""
    end)
    -- get query stringing
    url = string.gsub(url, "%?(.*)", function(q)
        parsed.query = q
        return ""
    end)
    -- get params
    url = string.gsub(url, "%;(.*)", function(p)
        parsed.params = p
        return ""
    end)
    -- path is whatever was left
    if url ~= "" then parsed.path = url end
    local authority = parsed.authority
    if not authority then return parsed end
    authority = string.gsub(authority,"^([^@]*)@",
        function(u) parsed.userinfo = u; return "" end)
    authority = string.gsub(authority, ":([^:]*)$",
        function(p) parsed.port = p; return "" end)
    if authority ~= "" then parsed.host = authority end
    local userinfo = parsed.userinfo
    if not userinfo then return parsed end
    userinfo = string.gsub(userinfo, ":([^:]*)$",
        function(p) parsed.password = p; return "" end)
    parsed.user = userinfo
    return parsed
end

local function make_headers(headers)
    local header = ""
    for key, value in pairs(headers) do
        header = header .. key .. ": " .. tostring(value) .. "\r\n"
    end
    return header
end

----------------------------------
--- function request({url,[...]})
----------------------------------
--  Accepts parameters: url, method, source, headers, bytes
--  Returns a table: {body = 'response body', code = 200, headers = 'All response headers'} or {err = 'something going wrong'}
--  Usage:  GET -->     http.request{url = "http://ww.myfavoritehost.com/folder/script.lua?q=anything"}
--          POST -->    http.request{url = "http://ww.myfavoritehost.com/script.lua", method = "POST", source = "first=1&more=in+ltn12+format", bytes = 50}
--  *Extra: Encodes a string into its escaped hexadecimal representation : http.escape("my strange / string") --> my%20strange%20%2f%20string
function request(params)
    if not params.url then
        return {err = "URL or host is required"}
    end
    local parsed_url = parse(params.url)
    
    params.method = params.method or "GET"
    params.method = string.upper(params.method)
    params.host = parsed_url.host
    params.port = parsed_url.port or 80
    params.script_path = ((parsed_url.path or "") .. (parsed_url.query and ("?"..parsed_url.query) or "") .. (parsed_url.fragment and "#"..parsed_url.fragment or "") ) or "/"
    params.source = (params.source and params.method == "POST") and "\r\n"..params.source or ""
    params.bytes = (tonumber(params.bytes) and tonumber(params.bytes) > 15) and tonumber(params.bytes) or 512
    params.ip = net.lookup(params.host)
    local headers = type(params.headers) == "table" and make_headers(params.headers) or ''
    
    local DEFAULT_HEADERS = {
    GET = {
        ["Host"] = params.host,
        ["User-Agent"] = "eLua net",
        },
    POST = {
            ["Host"] = params.host,
            ["Content-Length"] = string.len(params.source),
            ["User-Agent"] = "eLua/0.7",		
            ["Content-Type"] = "application/x-www-form-urlencoded",
        },
    HEAD = {
        ["Host"] = params.host,
        ["User-Agent"] = "eLua net",
        },
    PUT = {
        ["Host"] = params.host,
        ["User-Agent"] = "eLua net",
        },
    DELETE = {
        ["Host"] = params.host,
        ["User-Agent"] = "eLua net",
        },
    }
    
    if (not DEFAULT_HEADERS[params.method]) then
        return {err = "Invalid HTTP method"}
    end
    
    local req = string.format("%s %s HTTP/1.1\r\n%s%s%s\r\n", params.method, params.script_path, make_headers( DEFAULT_HEADERS[params.method] ), headers, params.source )
    
    local sock = net.socket(net.SOCK_STREAM)
    if net.connect(sock, params.ip, params.port) ~= 0 then
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
    local response, err_recv = net.recv( sock, params.bytes )
   
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
local resp = http.request{url = "http://192.168.1.1:9494//devices"}
print("CODE:",resp.code,"\r\n HEADERS:",resp.headers,"\r\n BODY:",resp.body,"\r\n")
print(2,"\r\n")

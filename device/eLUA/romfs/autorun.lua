require "net"
function getNewFile()
--    print "waiting for dhcp to settle"
--    tmr.delay( 0, 7000000 )
    print "connecting server"
    local server = net.packip(192,168,1,1)
    local socket = net.socket(net.SOCK_STREAM)
    local err = net.connect(socket, server, 4711)
    print "connected"
    local data = ""
    if err == net.ERR_OK then
--        local hwid = pd.id()
        local hwid = "1ab60832"
        print("HW-ID: "..hwid)
        local res,err = net.send(socket,hwid)
        print ("send= "..res..","..err)
        if err == net.ERR_OK then
            res,err = net.recv(socket, 5)
            print ("recv = <".. res..">,<"..err..">")
            local len = tonumber(res)
            print (len)
            net.send(socket,"OK")
            while err == net.ERR_OK and len > 0 do
                print "recv..\n"
                res,err = net.recv(socket, len)
    --            print ("recv = <".. res..">,<"..err..">")
                if err == net.ERR_OK then
    --                print(res)
                    len = len - #res
                    data = data .. res
                end
            end
            net.send(socket,"OK")
        else
            print "send failed"
        end
    else
        print ("connect error"..err)
    end
    net.close(socket)
    print (data)
    return data
end

function cacheAndStart(data)
    local filename="/mmc/e2dev.lua"
    if #data > 0 then
        print "===========save downloaded file to sd-card now================="
        local file = io.open(filename,"w")
        if file then
            file:write(data)
            file:close()
            print "===========execute file from sd-card now================="
            dofile(filename)
        else
            print "===========execute file from ram now================="
            local exe = loadstring(data)
            exe()
        end
    else
        print "===========execute old file from sd-card now================="
        dofile(filename)
    end
end
cacheAndStart(getNewFile())

-------------------------------------------------------------------------------
--
-- IP Editor eLua Snipper, for the LM3S8962
--
-- by Dado Sutter
-- October 2009
--
-------------------------------------------------------------------------------

-- on EK-LM3S8962 boards, the module EK-LM3S8962.lua will be required
local kit = require( pd.board() )  -- This variable is used as a pin assignments for the specific board

IP = {
  addr = '139.082.143.059',
  x = 25,
  y = 20,
  lvl = 12
}

title = {
  text = 'Ping Box',
  x = 40,
  y = 0,
  lvl = 12,
}

edit = {
  lvldim = 7,
  lvlcurrent = 12,
}


IP.digits = {}
for i = 1, 15 do
  IP.digits[i] = string.byte( IP.addr, i, i )
end

-- Init OLED RIT Display
local disp = lm3s.disp
disp.init( 1000000 )

-- Print Title
disp.print( title.addr , title.x, title.y, title.lvl )

-- Auxiliar Functions
function edit_IP( ip ) 
  local i = 1
    
  repeat
    disp.print( string.char( unpack( ip, 1, i-1 ) ), ip.x, ip.y, edit.lvldim )
    disp.print( string.char( ip[ i ] ), ip.x + (6*(i-1)), ip.y, edit.lvlcurrent )
    disp.print( string.char( unpack( ip, i+1, 15 ) ), ip.x + (6*i), ip.y, edit.lvldim ) 

    if kit.btn_pressed( kit.BTN_UP ) then
      if ip[ i ] < 57 then                           -- 57 = ASCII for 9
        ip[ i ] = ip[ i ] + 1
      else 
        ip[ i ] = 48                                 -- 48 = ASCII for 0
      end
      
    elseif kit.btn_pressed( kit.BTN_DOWN ) then
      if ip[ i ] > 48 then
        ip[ i ] = ip[ i ] - 1
      else 
        ip[ i ] = 57
      end
      
    elseif kit.btn_pressed( kit.BTN_RIGHT ) then
      if i < 15 then                                 -- 15 = size of IPv4 addr
        i = i + 1
        if ( ( i % 4 ) == 0 ) then
          i = i + 1
        end
      else
        i = 1
      end

    elseif kit.btn_pressed( kit.BTN_LEFT ) then
      if i > 1 then
        i = i - 1
        if ( ( i % 4 ) == 0 ) then
          i = i - 1
        end
      else
        i = 15
      end
    end  

  until kit.btn_pressed( kit.BTN_SELECT )

  ip.addr = string.char( unpack( ip, 1 ) )
  return ip
end


-- MAIN --
disp.print( ( edit_IP( IP ) ).addr, 20, 50, IP.lvl )





tmr.delay( 0, 1000000 )
lm3s.disp.init( 1000000 )
lm3s.disp.clear()                         -- This statements displays the game over screen
lm3s.disp.print( "Hallo Bosch", 30, 20, 11 )
lm3s.disp.print( "Glueckwunsch", 0, 40, 11 )
lm3s.disp.print( "zum 125. Geburtstag ", 15, 50, 11 )
lm3s.disp.print( "....noch so agil;-) ", 6, 70, 11 )
--print "test started"
--tmr.delay( 0, 7000000 --)
--print "test started"
---local file = io.open("/mmc/test.lua","w")
---if file then
---    file:write("print 'hallo du da'\n")
---    file:close()
---end

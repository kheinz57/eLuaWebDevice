---------------------------------------------------------------
-- Classic snake game
-- Still testing!
--
--                                      By Ives Negreiros and Téo Benjamin
---------------------------------------------------------------

lm3s.disp.init( 1000000 )
lm3s.disp.clear()
lm3s.disp.clear()                         -- This statements displays the game over screen
lm3s.disp.print( "Game Over :(", 30, 20, 11 )
lm3s.disp.print( "Your score was "..tostring( score ), 0, 40, 11 )
lm3s.disp.print( "Highscore: "..tostring( highscore ), 15, 50, 11 )
lm3s.disp.print( "SELECT to restart", 6, 70, 11 )
print "test started"


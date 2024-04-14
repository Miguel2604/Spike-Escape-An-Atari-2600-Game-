    x = 40
    y = 40
    COLUBK=$1C
    playfield:
..............................
..............................
..............................
..............................
..............................
.XXXX.XXXX.XXXX.XXXX.XXXX.XXXX
..............................
..............................
..............................
.XXXX.XXXX.XXXX.XXXX.XXXX.XXXX
end

main
    COLUPF=$0F
    COLUP0=$00
    player0:
        %00100100
        %01111110
        %11111111
        %11111111
        %01111110
end


   player0x = x
   player0y = y
   b = b+1
   if b>1 then pfscroll left

   if joy0up then y = y-1
   if joy0down then y = y+1
    
   if y<53 then y=53
   if y>72 then y=72

   drawscreen

   goto main 
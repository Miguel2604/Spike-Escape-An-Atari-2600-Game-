      x=50
      y=50
      a=$28
      
main
   COLUBK=$02
   COLUP0=a
   COLUPF=$0F
   playfield:
..............................
..............................
.XXXX.XXXXX.XXXXX.XXXXX.XXXXX.
..............................
..............................
..............................
..............................
.XXXX.XXXXX.XXXXX.XXXXX.XXXXX.
..............................
..............................
end
    player0:
            %00000000
            %00000000
            %00000000
            %00000000
            %00000000
            %00000000
            %00000000
            %00000000
            %00000000
            %00000000
            %00000000
            %00100100
            %01111110
            %11111111
            %11111111
            %01111110
end

   player0x = x
   player0y = y
   b=b+1
   if b>1 then pfscroll left

   if joy0up then y = y-1
   if joy0down then y = y+1

   if y<32 then y=32
   if y>89 then y=89

   drawscreen
   
   goto main 
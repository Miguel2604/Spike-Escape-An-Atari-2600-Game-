    x = 60 ; player0 x pos
    y = 60 ; player0 y pos
    a = 50 ; obstacle x pos
    b = 71 ; obstacle y pos
    r = 10 ; obstacle counter

    COLUBK=$1C

    goto MainMenuScreen


MainMenuScreen
        COLUPF = $0E
        playfield:
 XXXXX.XXXXX.XXXX.X..X.XXXXX.X..X
 X.....X...X.X..X.X..X.XXXXX.X..X
 X..XX.X..X..X..X.X..X.X.....XXXX
 X...X.X...X.XXXX.XXXX.X........X
 XXXXX...........................
 ...........................XXXXX
 XXXX..X.....XXXX.XXXX.X..X.....X
 XXXXX.X.....X..X.X....X.X..XXXXX
 X...X.X.....X..X.X....XXX......X
 XXXX..XXXXX.XXXX.XXXX.X..X.XXXXX
end

  drawscreen
 if joy0fire then goto gamestart
 goto MainMenuScreen

gamestart
    

        playfield:
 ..............................
 ..............................
 ..............................
 XXXXXXXXXX.XXXXXXXXX.XXXXXXXXX
 ..............................
 ..............................
 ..............................
 ..............................
 ..............................
 XXXXXXXXXX.XXXXXXXXX.XXXXXXXXX
end


main
    d = 50

    COLUPF=$0F
    COLUP0=$00
    COLUP1=$00
    player0: ; Car
        %00100100
        %01111110
        %11111111
        %11111111
        %01111110
end
 if r < 50 then   player1:       
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
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
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000       
end
 if r > 50 && r < 100 then   player1:
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
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
end
  if r > 100 && r < 150 then  player1:
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
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
end
    if r > 150 && r < 200 then  player1:
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
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
        %11000000
        %11000000
        %11000000
end

    if r > 200 && r < 255 then  player1:
        %11000000
        %11000000
        %11000000
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
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
        %11000000
end

   player0x = x
   player0y = y
   player1x = a 
   player1y = b
   
   c = c + 1
   if c>1 then pfscroll left
   
   a =  a - 2 
   
   if a < 5 then a = 160:score = score + 1: r = rand ; resets the obstacle's position to the start
                                                      ; increments the score, and randomizes the obstacle
   
   if joy0up then y = y-1 : AUDC0 = 4: AUDV0 = 2 : AUDF0 = 31 
   if joy0down then y = y+1 : AUDC0 = 4: AUDV0 = 2 : AUDF0 = 31 

   if !collision(player0,player1) then AUDC0 = 1: AUDV0 = 2 : AUDF0 = 31 else AUDC0 = 0
    
   if y<37 then y=37 ; restrains the car to not move past the road
   if y>72 then y=72

   if collision(player0,player1) then goto stopaftercollision   ; collision detection and health counter 
   drawscreen 

   goto main

stopaftercollision
   if d <= 50 && d > 25 then AUDC0 = 3 : AUDV0 = 2 : AUDV0 = 10 else AUDC0 = 0
   COLUP0 = $76
   player0:
    %00000000
    %00000000
    %00000000
    %00000000
    %00000000
    %10101010
    %10101000
    %11111010
    %10101010
    %10111010
    %00000010
    %10101010
    %10101010
    %11111010
    %10101010
    %10111010
end  
   player0x = x
   player0y = y
   player1x = a + 6
   player1y = b
   drawscreen
    
   if d > 1 then d = d - 1 else goto gameover 
   goto stopaftercollision
    

gameover
   
   player0x = 0
   player0y = 0
   player1x = 0 
   player1y = 0
   score = 0
 playfield:
 .XXX.XXX.XX.XX.XXX..............
 .X...X.X.X.X.X..................
 .X.X.XXX.X.X.X.XXX....X.X.X.X...
 .X.X.X.X.X.X.X..................
 .XXX.X.X.X.X.X.XXX..............
 ............XXXX.X.X.XXXXX.XX...
 ............X..X.X.X.X.....X.X..
 .X.X.X.X.X..X..X.X.X.X.XXX.XX...
 ............X..X.X.X.X.....X.X..
 ............XXXX..X..XXXXX.X.X..
 ................................
end
 
 drawscreen
 if joy0fire then player0x = 60 : player0y = 60 : a = 160 : b = 71 : goto gamestart
  
 goto gameover
 

 
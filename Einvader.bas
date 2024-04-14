 	rem
	rem Einvader
	rem Owen Cooper 2022 -  o_cooper@yahoo.com
	rem Instruction - START to start, and restart after GAME UNDER end screen
	rem Player laser base automatically moves under own steam and bounces at screen edge or when fire button is pressed
	rem Single invader passes right along screen and drops a line each time right screen edge is reached
	rem Doubles speed about halfway down screen - screen turns orange when invader is at double speed
	rem Trebles speed for last two rows - screen turns red
	rem After 5 invaders shot, all new invaders enter screen at double speed
	rem Game over if invader reaches floor
	rem 25 points for slow invader, 50 points for double speed invader, 200 points for treble speed invader
	rem

	rem TODO: sound

	rem ************** GAME SELECT SWITCH
	rem 1 - Normal Game
	rem 2 - Big bullets
	rem 3 - Little bullets
	rem 4 - Double speed invaders from the off
	rem 5 - HELL MODE Treble speed invaders from the off
	rem ************** 

	rem g is game type. Init it here so it stays constant between games
	g = 1 

initGame
	z = 0 : rem used as  count for dirty start switch debounce on title screen
	score = 0
	scorecolor = 30
	a = 1 : rem player movement vector
	b = 0 : rem player bullet live flag	
	c = 0 : rem fire button debounce
	d = 1 : rem invader speed
	e = 0 : rem odd even frame for animation
	f = 0 : rem used to count invaders shot
	h = 8 : rem default player0missile height
	i = 0 : rem 
	
	rem which game selection digit to display? 
	if g = 1 then gosub game1
	if g = 2 then gosub game2
	if g = 3 then gosub game3	
	if g = 4 then gosub game4	
	if g = 5 then gosub game5

initGame2
	COLUBK = 0
	COLUPF = 66
 playfield:
 ...............X.X..............
 ................................
 .XXX.X.XXX.X.X.XXX.XX..XXX.XXX..
 .......X.X.X.X.X.X.X.X.....X....
 .XXX.X.X.X.X.X.XXX.X.X.XXX.X....
 .....X.X.X.X.X.X.X.X.X.....X....
 .XXX.X.X.X..X..X.X.XX..XXX.X....
 ................................
 .X.X.X.X.X.X.X.X.X.X.X.X.X.X.X..
 ................................
 ................................
end

	drawscreen
	COLUP1 = 66
	rem slight delay to fake debounce the reset switch when coming here from game under
	rem otherwise we jump straight into game on subsequent plays because player can't come off
	rem the switch fast enough
	z = z + 1
	if z>50 &&  switchreset goto setUp
	if z = 255 then z = 0
	if switchselect then gosub selGame
	player1x = 120: player1y = 86 : rem being reused as digit to show selected game type
	goto initGame2

setUp
	rem setup player0 and player1 sprites from the oddFrame routine (player and invader respectively)
	gosub oddFrame
	COLUBK = 160
	COLUPF = 210
	player0x = 50:player0y=80
	player1x = 0:player1y = 16
	rem adjust player0missile height for games 2,3
	if g = 2 then h = 16
	if g = 3 then h = 1
	rem double speed invaders for game 4
	if g = 4 then d = 2
	rem treble speed invaders for game 5 HELL MODE!
	if g= 5 then d = 3


 playfield:
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end





mainLoop
	drawscreen

	rem wait 4 frames before swopping the animation frames otherwise it goes too fast
	if e < 4 then gosub evenFrame
	if e > 4  then gosub oddFrame
	e = e + 1 
	if e = 9 then e = 0

	gosub spriteColours


	rem fire button debounce 
	rem 0 = initial setting
	rem 1 = button released
	rem 2 = button down
	rem 3 = stop checking until 1
	if joy0fire && c<2 then c = 2
	if !joy0fire  then c=1

	if c=2 && a=1 then a=-1:c=3 : gosub bulletSpawn:  rem change vector to leftwards, flag to stop looking at button
	if c=2 && a=-1 then a=1:c=3: gosub bulletSpawn: rem change vector to rightwards, flag to stop looking at button

	rem adjust p1 x pos by the vector, bounce it at edge of playfield
	player0x = player0x + a
	if player0x>138 then a = -1
	if player0x <16  then a=1

	rem bullet movement and life - reset the flag once it leaves top edge of screen
	if b=1 then missile0y = missile0y -1
	if b=1 && missile0y = 0 then b=0 : AUDV0 = 0 

	rem invader behaviour - advance right by d (speed), run the invaderShiftDown code when right screen edge hit
	player1x = player1x + d
	if player1x >138 then gosub invaderShiftDown
	
	rem check invader landed
	if player1y>=80  then goto gameUnder

	rem invader shot?
	if collision(player1,missile0) then gosub invaderDie 

	goto mainLoop

evenFrame
 player0:
 %10101010
 %11111111
 %01100110
 %01111110
 %00111100
 %00011000
 %00011000
 %00011000
end

 player1:
 %11000011
 %01100110
 %11000011
 %11111111
 %11100111
 %01000010
 %01111110
 %11100111
end
	return

oddFrame
 player0:
 %01010101
 %11111111
 %01100110
 %01111110
 %00111100
 %00011000
 %00011000
 %00011000
end

 player1:
 %01100110
 %11000011
 %01100110
 %11111111
 %11100111
 %01000010
 %01111110
 %11100111
end
	return

invaderDeadSprite
 player1:
 %10001001
 %01000010
 %00100100
 %10000000
 %00000001
 %00100100
 %01000010
 %10010001
end
	return

bulletSpawn
	rem fire a bullet if no bullet in flight
	if b = 1 then return
	b = 1
	AUDC0 = 8 : AUDV0 = 8 : AUDF0 = 20
	missile0height = h
	missile0x = player0x
	missile0y = 72
	return

invaderDie
	rem reset the invader do some score stuff
	gosub invaderDeadSprite
	gosub invaderDieNoise
	f = f + 1 : rem keep a count for purposes of increasing the difficulty
	if f = 6 then f = 5 : rem don't count any more and don't risk going over 255 because that's arithmetic overflow in Batari world
	score = score + 25
	if player1y > 41 || d = 2 then score = score + 25 : rem 50 points  for double speed kill
	if player1y > 63 then score = score + 150 : rem 200 points for treble speed kill
	player1x = 0
	player1y = 8
	d = 1 : rem back to slow speed
	rem if > 5 invaders shot then slowest speed becomes 2
	if d = 1 &&  f>4 then d=2
	b = 0: missile0x = -10: missile0y = -10 : AUDV0 = 0 : rem kill off the missile
	rem game 4 is double speed at least
	if d = 1 && g = 4 then d = 2
	rem game 5 is treble speed all the time HELL MODE!!!!111
	if g = 5 then d = 3
	return

invaderDieNoise
	z = 0
	AUDC0 = 12 : AUDV0 = 13 : AUDF0 = 15
invaderDieNoise2
	z = z + 1
	rem leave this loop after set number of iterations, keeps SFX playing throughout
	if z > 8 then goto invaderDieNoise3
	gosub spriteColours
	drawscreen
	goto invaderDieNoise2
invaderDieNoise3
	rem silence the invader die SFX
	AUDV0 = 0
	return

invaderShiftDown
	rem check its y pos to adjust the speed
 	player1x = 16:player1y = player1y +8
	if player1y > 41  then d = 2 : rem double the x vector
	if player1y >63 then d = 3 : rem treble it on two last lines
	rem if > 5 invaders shot then slowest speed becomes 2 
	if d = 1 &&  f>4 then d=2
	rem game 4 is double speed at least
	if d = 1 && g = 4 then d = 2
	rem game 5 is treble speed all the time HELL MODE!!!!111
	if g = 5 then d = 3
	return

gameUnder
	rem end of game routine, new playfield to display message
	rem hide player, invader, missile off screen
	player0x = -4:player0y = -4
	player1x = -4:player1y = -4
	missile0x = -4: missile0y = -4
 	y = 0 : rem game under SFX not played yet
gameUnder2
	COLUBK = 0
	COLUPF = 66

 playfield:
 XXX.XXX.XX.XX.XXX...............
 X...X.X.X.X.X...................
 X.X.XXX.X.X.X.XXX....X.X.X.X.X..
 X.X.X.X.X.X.X...................
 XXX.X.X.X.X.X.XXX...............
 ................................
 ............X..X.XXX.XX..XXX.XX.
 ............X..X.X.X.X.X.....X.X
 .X.X.X.X.X..X..X.X.X.X.X.XXX.XX.
 ............X..X.X.X.X.X.....X.X
 .............XX..X.X.XX..XXX.X.X
end
	drawscreen
	z = 0
	if y = 1 then goto gameUnderSF2 : rem skip the game under SFX if already played
	AUDC0 = 2 : AUDV0 = 15 : AUDF0 = 6
gameUnderSFX
	y = 1 : rem set flag we already played this
	z = z + 1
	if z > 45 then goto gameUnderSF2
	drawscreen
	goto gameUnderSFX
gameUnderSF2
	AUDV0 = 0

 	if switchreset then goto initGame
	goto gameUnder2

spriteColours
	rem change background to match the panic factor - how low is the invader getting?
	rem remember you need to set the player sprites colours every loop or they get reset to the score colours due to some quirk of Batari
	if player1y < 42 then COLUBK = 160:COLUP0 = 78: COLUP1 = 222
	if player1y > 41 && player1y < 63 then COLUBK = 56:COLUP0 = 0: COLUP1 = 222
	if player1y > 63 then COLUBK = 64:COLUP0 = 0:COLUP1 = 0
	return

selGame	
	rem increment game type roll over to 1 if 6. Jump to the relevant defining code for player0 sprite
	rem as we use that as numbers (copied from Atari ST charset) to show current selection
	g =g + 1: if g = 6 then g = 1
	if g = 1 then gosub game1
	if g = 2 then gosub game2
	if g = 3 then gosub game3	
	if g = 4 then gosub game4	
	if g = 5 then gosub game5
	rem wait here drawscreen-ing until select switch released
selGameDebounce
	if switchselect then drawscreen: goto selGameDebounce 
	return
	
game1
 player1:
 %01111110
 %00011000
 %00011000
 %00011000
 %00011000
 %00111000
 %00011000
 %00000000
end
	return
game2
 player1:
 %01111110
 %00110000
 %00011000
 %00001100
 %00000110
 %01100110
 %00111100
 %00000000
end
	return
game3
 player1:
 %00111100
 %01100110
 %00000110
 %00001100
 %00011000
 %00001100
 %01111110
 %00000000
end
	return
game4
 player1:
 %00001100
 %00001100
 %01111110
 %01101100
 %00111100
 %00011100
 %00001100
 %00000000
end
	return
game5
 player1:
 %00111100
 %01100110
 %00000110
 %00000110
 %01111100
 %01100000
 %01111110
 %00000000
end
	return


/*
 PROJECT TITLE: Snake Game
 NAME: Aashir Alam
 DATE: 22/11/21
 FILE NAME: snake_game.t
 TEACHER: Mr. Bonisteel
 DESCRIPTION: Snake game in turing, eat apples to grow, avoid tail and walls
 speed of snake increases every apple you eat, eat blue ice to slow down,
 and eat lucky blocks to get a special suprise !
 

 wasd to move
 */

import GUI
setscreen ("graphics:700;600")
setscreen ("offscreenonly")

var chars : array char of boolean

% Fonts
var title_font := Font.New ("Comicsans:25:bold")
var score_font := Font.New ("Comicsans:15:bold")
var instructions_font := Font.New ("Comicsans:15")
var power_up_font := Font.New ("Comicsans:15")

% Images
var snake_image : int := Pic.FileNew ("snake.bmp")
var lucky_block : int := Pic.FileNew ("lucky_block.bmp")
var suprise_image : int := Pic.FileNew ("suprise_image.bmp")


var direction : string := "stop"
var speed : int := 5

var head_size : int := 15
var segment_size : int := 10

var head_x : int := 350
var head_y : int := 300
var tail_size : int := 1

var score : int := 0
var high_score : int := 0

var place_ice : boolean := false
var place_lucky_block : boolean := false


var soundtrack_num : int := 1

%% MUSIC PROCESSES / PROCEDURES %%%
process play_music (soundtrack_num : int)
    var soundtrack : string := "soundtrack" + intstr(soundtrack_num) + ".wav"
    var num : int := soundtrack_num
    
    loop
	Music.PlayFile (soundtrack)
	delay (1000)
	if num = 3 then
	    num := 1
	    
	else
	    num := num + 1
	
	end if
	soundtrack := "soundtrack" + intstr(num) + ".wav"
	
    end loop

end play_music


procedure play_soundtrack_1
    soundtrack_num := 1
    fork play_music(soundtrack_num)

end play_soundtrack_1


procedure play_soundtrack_2
    soundtrack_num := 2
    fork play_music(soundtrack_num)

end play_soundtrack_2


procedure play_soundtrack_3
    soundtrack_num := 3
    fork play_music(soundtrack_num)

end play_soundtrack_3


%%% GAME PROCEDURES %%%

procedure reset_game ()
    Font.Draw("You Lost ! Press 'r' to restart", 225, maxy div 2, score_font, 40)
    View.Update()
    
    loop
    Input.KeyDown(chars)
    delay(50)
    exit when chars('r')
    end loop
    
    direction := "stop"
    head_x := 350
    head_y := 300
    tail_size := 1
    head_size := 15
    segment_size := 10
    speed := 5
    score := 0
    place_ice := false
    place_lucky_block := false

end reset_game


% Main game
procedure start_game
    
    % X and Y position of apple, ice and lucky block
    var apple_x : int
    var apple_y : int

    var ice_x : int
    var ice_y : int
    
    var lucky_block_x : int
    var lucky_block_y : int
    
    var lucky_block_num : int % Random integer to decide which power up (or down) will be applied after collecting lucky block
    
    % Distance x and y variables for checking collision with snake head
    var ice_dist_x : int
    var ice_dist_y : int

    var apple_dist_x : int
    var apple_dist_y : int

    var head_dist_x : int
    var head_dist_y : int

    var lucky_block_dist_x : int
    var lucky_block_dist_y : int

    var body_x : array 1 .. 100 of int
    var body_y : array 1 .. 100 of int

    var segment_x : int
    var segment_y : int
    
    % Variables for lucky block
    var tail_size_change : int
    var speed_change : int
    var score_change : int
    
    
    % Choose random positions for apple, ice and lucky block
    randint (apple_x, 20, 680)
    randint (apple_y, 20, 580)

    randint (ice_x, 20, 680)
    randint (ice_y, 20, 580)

    randint (lucky_block_x, 0, 650)
    randint (lucky_block_y, 0, 550)


    loop
	Input.KeyDown (chars)
	
	% Draw high score and score
	Font.Draw ("High Score: " + intstr (high_score), 300, maxy - 25, score_font, yellow)
	Font.Draw ("Score: " + intstr (score), 325, maxy - 75, score_font, yellow)
	
	% Change direcction based on key press
	if chars ('w') and direction not= "down" then
	    direction := "up"

	elsif chars ('a') and direction not= "right" then
	    direction := "left"


	elsif chars ('s') and direction not= "up" then
	    direction := "down"

	elsif chars ('d') and direction not= "left" then
	    direction := "right"

	end if
	
	% Change head x / y depending on snake direction
	if direction = "up" then
	    head_y := head_y + speed

	elsif direction = "down" then
	    head_y := head_y - speed

	elsif direction = "left" then
	    head_x := head_x - speed

	elsif direction = "right" then
	    head_x := head_x + speed

	end if
	
	% Check collision with apple

	apple_dist_x := abs (apple_x - head_x)
	apple_dist_y := abs (apple_y - head_y)

	if apple_dist_x < head_size and apple_dist_y < head_size then
	    randint (apple_x, 20, 680)
	    randint (apple_y, 20, 580)

	    randint (ice_x, 20, 680)
	    randint (ice_y, 20, 580)

	    randint (lucky_block_x, 50, 650)
	    randint (lucky_block_y, 50, 550)

	    body_x (tail_size) := 0
	    body_y (tail_size) := 0

	    score := score + 1
	    
	    if score > high_score then
		high_score := score
	    
	    
	    end if
	    speed := speed + 1
	    tail_size := tail_size + 1

	    if score >= 15 then
		if (Rand.Int (0, 4) = 0) then % 20 percent chace of spawning lucky block
		    place_lucky_block := true

		else
		    place_lucky_block := false


		end if

	    end if

	    if score >= 10 then
		if Rand.Int (0, 1) = 1 then % 50 percent chace of spawning ice
		    place_ice := true

		else
		    place_ice := false

		end if

	    end if

	end if
	
	% Ice

	if (place_ice = true) then
	    drawfillbox (ice_x - 10, ice_y - 10, ice_x + 10, ice_y + 10, 32)
	    ice_dist_x := abs (ice_x - head_x)
	    ice_dist_y := abs (ice_y - head_y)

	    if ice_dist_x < head_size and ice_dist_y < head_size then
		randint (apple_x, 20, 680)
		randint (apple_y, 20, 580)

		randint (ice_x, 20, 680)
		randint (ice_y, 20, 580)

		randint (lucky_block_x, 50, 650)
		randint (lucky_block_y, 50, 550)

		speed := speed - 2
		
		if speed < 0 then
		    speed := 1
		end if

		if Rand.Int (0, 1) = 1 then
		    place_ice := true

		else
		    place_ice := false

		end if

		if Rand.Int (0, 4) = 1 and score >= 15 then
		    place_lucky_block := true

		else
		    place_lucky_block := false


		end if

	    end if


	end if
	
	
	% Lucky block

	if (place_lucky_block = true) then
	    Pic.Draw (lucky_block, lucky_block_x, lucky_block_y, picCopy)

	    lucky_block_dist_x := abs (lucky_block_x - head_x)
	    lucky_block_dist_y := abs (lucky_block_y - head_y)

	    if (head_x > lucky_block_x and head_x < lucky_block_x + 50) and (head_y > lucky_block_y and head_y < lucky_block_y + 50)  then
		randint (apple_x, 20, 680)
		randint (apple_y, 20, 580)

		randint (ice_x, 20, 680)
		randint (ice_y, 20, 580)

		randint (lucky_block_x, 50, 650)
		randint (lucky_block_y, 50, 550)
		
		% Decide lucky block power up or down
		lucky_block_num := Rand.Int(0, 4)
		
		if lucky_block_num = 0 then
		    % Increase / decrease score
		    score_change := Rand.Int(-20, 50)
		    score := score + score_change
		    
		    if score > high_score then
			high_score := score
			
		    end if
		    
		    
		
		elsif lucky_block_num = 1 then
		    % Increase / decrease score
		    speed_change := Rand.Int(-5, 5)
		    speed := speed + speed_change
		    
		    if speed < 0 then
			speed := 1
		    
		    end if
		     
		    
		elsif lucky_block_num = 2 and tail_size >= 7 then
		    % Increase / decrease snake size
		    tail_size_change := Rand.Int(-5, 5)
		    tail_size := tail_size + tail_size_change
		    
		    for body_index : 1 .. tail_size
			body_x (body_index) := 0
			body_y (body_index) := 0
		    
		    end for

		    
		elsif lucky_block_num = 2 then
		    % Increase tail size if body size is less than 7
		    tail_size_change := Rand.Int(1, 5)
		    tail_size := tail_size + tail_size_change
		    
		    for body_index : 1 .. tail_size
			body_x (body_index) := 0
			body_y (body_index) := 0

		    end for
		    
		    
		elsif lucky_block_num = 3 then
		    % Get rid of snake tail
		    tail_size := 1

		
		elsif lucky_block_num = 4 and head_size >= 10 then
		    % Increase / decrease head size
		    head_size := head_size + Rand.Int(-5, 5)
		    segment_size := head_size - 5
		    
		    
		else
		    % Increase head size if head size is less than 10
		    head_size := head_size + Rand.Int(1, 5)
		    segment_size := head_size - 5
		    
		end if
		
		if Rand.Int (0, 4) = 1 and score >= 15 then % 20 percent chance of placing lucky_block
		    place_lucky_block := true

		else
		    place_lucky_block := false

		end if


		if Rand.Int (0, 1) = 1 then % 50 percent chance of placing ice
		    place_ice := true

		else
		    place_ice := false

		end if

	    end if

	end if


	% Draw snake head and apple
	drawfillbox (head_x - head_size, head_y - head_size, head_x + head_size, head_y + head_size, green)
	drawfillbox (apple_x - 10, apple_y - 10, apple_x + 10, apple_y + 10, red)

	% Draw snake tail
	if tail_size > 0 then
	    for decreasing body_index : tail_size .. 1
		if body_index = 1 then
		    segment_x := head_x
		    segment_y := head_y

		else
		    segment_x := body_x (body_index - 1)
		    segment_y := body_y (body_index - 1)

		end if

		body_x (body_index) := segment_x
		body_y (body_index) := segment_y

		drawfillbox (segment_x - segment_size, segment_y - segment_size, segment_x + segment_size, segment_y + segment_size, green)

	    end for


	end if
	
	% Check if head hit a wall
	if head_x + head_size >= maxx or head_x - head_size <= 0 or head_y + head_size >= maxy or head_y - head_size <= 0 then
	    reset_game ()

	end if


	% Check if head is inside tail
	if tail_size > 4 and direction not= "stop" then
	    for body_index : 4 .. tail_size
		segment_x := body_x (body_index)
		segment_y := body_y (body_index)

		head_dist_x := abs (segment_x - head_x)
		head_dist_y := abs (segment_y - head_y)

		if head_dist_x < 10 and head_dist_y < 10 then
		    reset_game ()

		end if


	    end for

	end if

	colorback (200)
	View.Update ()
	delay (50)
	cls

    end loop

end start_game

procedure instructions

    var mouse_x : int
    var mouse_y : int
    var mouse_clicked : int

    loop
	% Draw instructions text
	Font.Draw ("Instructions", 275, maxy - 50, title_font, yellow)
	Font.Draw ("Use WASD to move the snake", 50, 450, instructions_font, yellow)
	Font.Draw ("Eat red apples to grow your snake, increase your score and speed", 50, 350, instructions_font, yellow)
	Font.Draw ("Eat blue ice to slow down your snake, they don't give any points !", 50, 250, instructions_font, yellow)
	Font.Draw ("Eat lucky blocks if you are feeling lucky to get a power up (or down...)", 50, 150, instructions_font, yellow)
	
	% Draw exit button
	drawfillbox (20, maxy - 60, 80, maxy - 10, red)
	Font.Draw ("X", 40, maxy - 50, title_font, white)

	Mouse.Where (mouse_x, mouse_y, mouse_clicked)

	colorback (200)
	% Exit when "X" button is clicked
	exit when (mouse_x > 20 and mouse_x < 80) and (mouse_y > maxy - 60 and mouse_y < maxy - 10) and mouse_clicked = 1
	
	View.Update ()
	cls
	delay (10)
    end loop

    start_game ()

end instructions


procedure start_screen

    drawfillbox (0, 0, maxx, maxy, 200)
    
    % Buttons
    var start_button : int := GUI.CreateButton (200, 400, 0, "Start Game", start_game)
    var instructions_button : int := GUI.CreateButton (400, 400, 0, "Instructions", instructions)
    var soundtrack1_button : int := GUI.CreateButton (100, 300, 0, "Soundtrack 1", play_soundtrack_1)
    var soundtrack2_button : int := GUI.CreateButton (300, 300, 0, "Soundtrack 2", play_soundtrack_2)
    var soundtrack3_button : int := GUI.CreateButton (500, 300, 0, "Soundtrack 3", play_soundtrack_3)


    Font.Draw ("Snake Game", 250, 500, title_font, yellow)
    Pic.Draw (snake_image, 225, 125, picCopy)
    View.Update ()

    loop
	% Exit's when any button is clicked
	exit when GUI.ProcessEvent
	delay (10)
    end loop
    
    % Free memory of snake image
    Pic.Free (snake_image)

end start_screen


% Start program
start_screen ()



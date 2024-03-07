extends Node2D

@onready var tile_map =  $"../TileMap"

@onready var timer = $"../TileMap/Timer"
@onready var gameover_timer = $"../TileMap/GameOverTimer"
@onready var flood_timer = $"../TileMap/FloodTimer"

var font = load("res://PressStart2P.ttf")

var tutorial_label = Label.new()
var except_start = Vector2i(0,0)
var except_end = Vector2i(16,12)

const LAYERS = {
	"ground" : 0,
	"top" : 1,
	"flood" : 2,
	"highlight" : 3,
	"tutorial_border_0" : 4,
	"tutorial_border_1" : 5,
	"tutorial_border_2" : 6,
	"tutorial_border_3" : 7,
	"tutorial_border_4" : 8,
	"tutorial_border_5" : 9,
	"tutorial_border_6" : 10,
	"tutorial_border_7" : 11,
	"tutorial_border_8" : 12,
	"tutorial_border_9" : 13,
	"tutorial_map"		: 14
}

func _ready():
	print(Global.tutorial_count)
	if Global.tutorial_count >= 0:
		#create quit tutorial button
		var quit_tutorial_button = Button.new()
		quit_tutorial_button.set_position(Vector2(100,450))
		quit_tutorial_button.text = "quit"
		quit_tutorial_button.add_theme_font_override("font",font)
		#quit_tutorial_button.add_theme_font_size_override("font_size",10)
		quit_tutorial_button.pressed.connect(self._on_quit_tutorial_button_pressed)
		add_child(quit_tutorial_button)
		
		#create next tutorial button
		var next_tutorial_button = Button.new()
		next_tutorial_button.set_position(Vector2(700,450))
		next_tutorial_button.text = "next"
		next_tutorial_button.add_theme_font_override("font",font)
		next_tutorial_button.pressed.connect(self._on_next_tutorial_button_pressed)
		add_child(next_tutorial_button)
		
		#create previous tutorial button
		var restart_tutorial_button = Button.new()
		restart_tutorial_button.set_position(Vector2(500,450))
		restart_tutorial_button.text = "reset"
		restart_tutorial_button.add_theme_font_override("font",font)
		restart_tutorial_button.pressed.connect(self._on_restart_tutorial_button_pressed)
		add_child(restart_tutorial_button)
		
		#create previous tutorial button
		var previous_tutorial_button = Button.new()
		previous_tutorial_button.set_position(Vector2(300,450))
		previous_tutorial_button.text = "back"
		previous_tutorial_button.add_theme_font_override("font",font)
		previous_tutorial_button.pressed.connect(self._on_previous_tutorial_button_pressed)
		add_child(previous_tutorial_button)
		
		do_tutorial()
		
func _on_previous_tutorial_button_pressed():
	tutorial_count_change(-1)
	Global.switch_scene("res://mainGame.tscn")
	
func _on_restart_tutorial_button_pressed():
	#tutorial_count_change(-1)
	Global.switch_scene("res://mainGame.tscn")
	
		
func _on_next_tutorial_button_pressed():
	tutorial_count_change(1)
	Global.switch_scene("res://mainGame.tscn")
	
func _on_quit_tutorial_button_pressed():
	print("quit tutorial")
	Global.switch_scene("res://main menu/main menu/main_menu.tscn")
	

func tutorial_count_change(dif):
	if Global.tutorial_count == 0 and dif < 0:
		return 
	elif Global.tutorial_count == 9 and dif > 0:
		return
		
	Global.tutorial_count += dif
	
	
		
func do_tutorial():
	except_start = Vector2i(0,0)
	except_end = Vector2i(0,0)
	var tutorial_count = Global.tutorial_count
	
	tutorial_label.add_theme_font_override("font",font)
	tutorial_label.add_theme_font_size_override("font_size",10)
	tutorial_label.text = ""
	
	#unable all tutorial layer
	for i in range(4,15):
		tile_map.set_layer_enabled(i, false)
		
	if tutorial_count == 0:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_0"], true)
		
		tutorial_label.set_position(Vector2(50,370))
		tutorial_label.text = "Oh no! There's heavy rain in the mountains for the first time in 100 years!
							
							Please help people evacuate by delaying the flood, Mayor!"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		
		if tutorial_label not in get_children():
			add_child(tutorial_label)
		
	elif tutorial_count == 1:		
		tile_map.set_layer_enabled(LAYERS["tutorial_border_1"], true)
		#tutorial_label = Label.new()
		tutorial_label.set_position(Vector2(150,250))
		tutorial_label.text = "Water (blue tiles) flows toward the dry riverbed (brown tile)
		
								Dark blue is deeper, so it can flow to the riverbed next to it.
								
								
								
								
								
								Shallow                             Deep"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))

		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(6,0)
		except_end = Vector2i(12,5)
		
		
		
	elif tutorial_count == 2:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_2"], true)
		tile_map.set_layer_enabled(LAYERS["tutorial_map"], true)
		
		tutorial_label.set_position(Vector2(50,200))
		tutorial_label.text = "If the river reaches the bottom of the map (city limit), the city is flooded.
		
							Your task is to delay the flood so more people can escape
							
							If the river reaches the city..."
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))		
		
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(5,8)
		except_end = Vector2i(13,13)
		
		
		tile_map.set_cell(LAYERS["ground"], Vector2i(6,8), 0, Vector2i(0,0))
		tile_map.set_cell(LAYERS["ground"], Vector2i(7,8), 0, Vector2i(0,0))
		
		while not gameover_timer.is_stopped():
			
			#wait until the timer runs out of time (until river change state)
			await get_tree().create_timer(timer.wait_time).timeout
			
			tile_map.set_cell(LAYERS["ground"], Vector2i(8, 8), 0, Vector2i(4,0))
			#tile_map.set_cell(LAYERS["ground"], Vector2i(8,10), 0, Vector2i(4,0))
			#if just_before_gameover state, pop out game over
			
		tutorial_label.set_position(Vector2(170,200))
		tutorial_label.text = "GAME OVER!!!"
		tutorial_label.add_theme_color_override("font_color",Color(1,0,0,1))
		tutorial_label.add_theme_font_override("font",font)
		tutorial_label.add_theme_font_size_override("font_size",30)
		
		for x in range(3,16):
			for y in range(1,3):
				var curr_atlas = tile_map.get_cell_atlas_coords(LAYERS["tutorial_map"], Vector2i(x,y))
				if curr_atlas in [Vector2i(0,0), Vector2i(1,0), Vector2i(2,0)]:
					tile_map.set_cell(LAYERS["tutorial_map"], Vector2i(x,y), 1, curr_atlas + Vector2i(0,1))
			
		
	elif tutorial_count == 3:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_3"], true)
		tutorial_label.set_position(Vector2(50,100))
		tutorial_label.text = 	"You can see your score, money,
								 and tile selection on the right.
		
								The score and money increases as time goes on.
								
								You can change the tile you're placing
								 by using the ASDF keys.
								
								These items are placable by spending money.
								
								Try to get a higher score!
								
								
								
								
								
								
								
								
								
								Press ASDF 
								 to change tile selection
								"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
	elif tutorial_count == 4:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_8"], true)
		tutorial_label.set_position(Vector2(50,50))
		tutorial_label.text = "You can see there are different tiles
		
								You need to protect houses and cars
								- If next to river tile, they'll be flooded
								- If they are flooded/broken, you'll lose score
								
								Rock tiles are unchangeable
								
								The city at the bottom will be destroyed eventually...
								"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(3,6)
		except_end = Vector2i(13,11)
		
		while true:
			#wait until the timer runs out of time (until river change state)
			await get_tree().create_timer(timer.wait_time).timeout
			tile_map.set_cell(LAYERS["ground"],Vector2i(3,6), 0, Vector2i(4,0))
		
	elif tutorial_count == 5:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_4"], true)
		tutorial_label.set_position(Vector2(50,250))
		tutorial_label.text = "Try digging!! ->
		
		
		
							You can dig the river to divert the river's direction
		
								You cannot make a pond (4-tile square)
								
								Press S to start digging
								 if you are in a different mode
								
								Digging costs 5 money"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(6,0)
		except_end = Vector2i(16,6)
		
	elif tutorial_count == 6:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_5"], true)
		tutorial_label.set_position(Vector2(50,250))
		tutorial_label.text =  " Try pumping!!!
		
		
		
								You can use a pump to stop river from flowing
								 for 20 seconds though...
		
								Press D and place it 
								 on a green (ground) tile next to river 
								
								If a house or car is flooded, 
								 you can place a pump next to it to drain it
								
								A pump costs 20 money"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(0,0)
		except_end = Vector2i(7,5)
		
		while true:
			
			#wait until the timer runs out of time (until river change state)
			await get_tree().create_timer(timer.wait_time).timeout
			
			tile_map.set_cell(LAYERS["ground"], Vector2i(7,5), 0, Vector2i(4,0))
		
	elif tutorial_count == 7:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_6"], true)
		tutorial_label.set_position(Vector2(50,80))
		tutorial_label.text = "                 Place cistern next to pump\n\n\n\n\n\n                <- Try comparing power!!!
		
		
		
		
		
		
		
		
		
		
		
								You can use a cistern to increase the power of pump
		
								Press F and place it 
								 on a green (ground) tile next to the pump 
								
								A cistern costs 10 money"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(0,0)
		except_end = Vector2i(4,7)
		
		tile_map.set_cell(LAYERS["top"], Vector2i(5,2)) #delete house
		
		for y in range(1,7):
			tile_map.set_cell(LAYERS["ground"],Vector2i(1,y), 0, Vector2i(3,0))
			tile_map.set_cell(LAYERS["ground"],Vector2i(3,y), 0, Vector2i(3,0))
			
		tile_map.set_cell(LAYERS["ground"],Vector2i(2,1), 0, Vector2i(3,0))
		tile_map.set_cell(LAYERS["ground"],Vector2i(3,1), 0, Vector2i(3,0))
		tile_map.set_cell(LAYERS["ground"],Vector2i(2,3), 0, Vector2i(3,0))
		tile_map.set_cell(LAYERS["ground"],Vector2i(4,3), 0, Vector2i(3,0))
		tile_map.set_cell(LAYERS["ground"],Vector2i(2,6), 0, Vector2i(3,0))
		tile_map.set_cell(LAYERS["ground"],Vector2i(3,7), 0, Vector2i(3,0))
		tile_map.set_cell(LAYERS["ground"],Vector2i(4,7), 0, Vector2i(3,0))
		
	elif tutorial_count == 8:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_8"], true)
		tutorial_label.set_position(Vector2(50,50))
		tutorial_label.text = "You can undig the riverbed (brown tile) and river
		
								Undigging can stop river flow but
								 river must connect to the bottom of the map!
								
								You need 5 money to undig riverbed
								
								You need 10 money to dig shallow river
								
								You need 15 money to dig deep river\n\n            Try Undigging!!!\n\n\n\n\n\n\n\n\n                                            See Change?\n                                              ------>"		
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(3,6)
		except_end = Vector2i(13,11)
		
		while true:
			#wait until the timer runs out of time (until river change state)
			await get_tree().create_timer(timer.wait_time).timeout
			tile_map.set_cell(LAYERS["ground"],Vector2i(3,6), 0, Vector2i(4,0))
		
	elif tutorial_count == 9:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_9"], true)
		tutorial_label.set_position(Vector2(50,200))
		tutorial_label.text = "Tutorial Completed!"
		tutorial_label.add_theme_color_override("font_color",Color(1,1,0))
		tutorial_label.add_theme_font_size_override("font_size",40)
		
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		var x = -1
		var y = -1
		while y<15:
			await get_tree().create_timer(0.05).timeout
			if x%5 == 0:
				tutorial_label.text = ""
			else:
				tutorial_label.text = "Tutorial Completed!"
			
			tile_map.set_cell(LAYERS["tutorial_border_9"], Vector2i(x,y), 0, Vector2i(2,0))
			tile_map.set_cell(LAYERS["tutorial_border_9"], Vector2i(x-1,y), 0, Vector2i(3,0))
			tile_map.set_cell(LAYERS["tutorial_border_9"], Vector2i(x-2,y), 0, Vector2i(4,0))
			
			x = (x+1)%29
			y = y + x/28
			
		
		tutorial_label.text = "If you want, you can try hard mode
								 - starting from the straight riverbed
								 - faster river flow 
								
							Press plus key (shift+equal)
							 after going back to the starting screen"
		tutorial_label.add_theme_color_override("font_color",Color(1,1,1))
		tutorial_label.add_theme_font_size_override("font_size",10)
		tutorial_label.set_position(Vector2(200,350))
			
	
func set_outside_border():
	var sx = except_start[0]
	var sy = except_start[1]
	var ex = except_end[0]
	var ey = except_end[1]
	
			
	for y in range(0, 13):
		if sx > 0:
			tile_map.set_cell(LAYERS["ground"], Vector2i(sx-1, y), 0, Vector2i(0,0))
		if ex < 16:
			tile_map.set_cell(LAYERS["ground"], Vector2i(ex+1, y), 0, Vector2i(0,0))
		
	for x in range(0, 17):
		if ey <= 9:
			tile_map.set_cell(LAYERS["ground"], Vector2i(x, sy+2), 0, Vector2i(1,0))
			tile_map.set_cell(LAYERS["ground"], Vector2i(x, ey+1), 0, Vector2i(0,0))
		
	
	for y in range(0, 13):
		if sx > 1:
			tile_map.set_cell(LAYERS["ground"], Vector2i(sx-2, y), 0, Vector2i(1,0))
		if ex < 15:
			tile_map.set_cell(LAYERS["ground"], Vector2i(ex+2, y), 0, Vector2i(1,0))

func drain_all_water():
	var sx = except_start[0]
	var sy = except_start[1]
	var ex = except_end[0]
	var ey = except_end[1]
	
	for x in range(17):
		for y in range(13):
			var within_exception = sx <= x and x <= ex and sy <= y and y <= ey
			if within_exception:
				continue
				
			var is_water = tile_map.get_cell_atlas_coords(LAYERS["ground"], Vector2i(x,y))\
						 in [Vector2i(2,0), Vector2i(3,0), Vector2i(4,0)]
			#print(tile_map.get_cell_atlas_coords(LAYERS["ground"], Vector2i(x,y)))
			if is_water:
				#change to riverbed
				tile_map.set_cell(LAYERS["ground"], Vector2i(x,y), 0, Vector2i(1,0))
				

				
func _input(_event):
	if Input.is_action_just_pressed("click"): 
		var mouse_pos : Vector2i = get_global_mouse_position() #global position in float
		var tile_mouse_pos : Vector2i = tile_map.local_to_map(mouse_pos) #local position in int
		
		var sx = except_start[0]
		var sy = except_start[1]
		var ex = except_end[0]
		var ey = except_end[1]
		
		var x = tile_mouse_pos[0] - 1
		var y = tile_mouse_pos[1] - 1
	
		var within_border = sx <= x and x <= ex and sy <= y and y <= ey
		var within_frame = 0 <= x and x <= 16 and 0 <= y and y <= 12
		if not within_border and within_frame:			
			get_viewport().set_input_as_handled()
			return
				
func _on_game_over_timer_timeout():
	if Global.tutorial_count == 2:
		var just_before_gameover = tile_map.get_cell_atlas_coords(LAYERS["flood"], Vector2i(1,12)) \
									== Vector2i(2,0)
		
		#print("not stopped")
		if just_before_gameover:
			gameover_timer.stop()
			flood_timer.stop()
		

func _on_timer_timeout():
	if Global.tutorial_count >= 0:
		drain_all_water()

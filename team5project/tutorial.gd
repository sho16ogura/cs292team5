extends Node2D

@onready var tile_map =  $"../TileMap"

@onready var timer = $"../TileMap/Timer"
@onready var gameover_timer = $"../TileMap/GameOverTimer"
@onready var flood_timer = $"../TileMap/FloodTimer"


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
	"tutorial_border_9" : 13
}

func _ready():
	print(Global.tutorial_count)
	if Global.tutorial_count >= 0:
		#create quit tutorial button
		var quit_tutorial_button = Button.new()
		quit_tutorial_button.set_position(Vector2(100,450))
		quit_tutorial_button.text = "back to main menu"
		quit_tutorial_button.pressed.connect(self._on_quit_tutorial_button_pressed)
		add_child(quit_tutorial_button)
		
		#create next tutorial button
		var next_tutorial_button = Button.new()
		next_tutorial_button.set_position(Vector2(700,450))
		next_tutorial_button.text = "next"
		next_tutorial_button.pressed.connect(self._on_next_tutorial_button_pressed)
		add_child(next_tutorial_button)
		
		#create previous tutorial button
		var restart_tutorial_button = Button.new()
		restart_tutorial_button.set_position(Vector2(520,450))
		restart_tutorial_button.text = "reset"
		restart_tutorial_button.pressed.connect(self._on_restart_tutorial_button_pressed)
		add_child(restart_tutorial_button)
		
		#create previous tutorial button
		var previous_tutorial_button = Button.new()
		previous_tutorial_button.set_position(Vector2(350,450))
		previous_tutorial_button.text = "back"
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
	#print(tutorial_count)
	#unable all tutorial layer
	for i in range(4,14):
		tile_map.set_layer_enabled(i, false)
		
	if tutorial_count == 0:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_0"], true)
		
		tutorial_label.set_position(Vector2(150,200))
		tutorial_label.text = "Woops! Heavy rain in mountain! First time in 100 years!\n Please help people evacuate by gaining time, Mayor!"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
		
	elif tutorial_count == 1:		
		tile_map.set_layer_enabled(LAYERS["tutorial_border_1"], true)
		#tutorial_label = Label.new()
		tutorial_label.set_position(Vector2(150,250))
		tutorial_label.text = "Water (blue tiles) flows toward dry riverbed (brown tile)
								Dark blue is deeper, so it can flow to the riverbed next to it."
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(6,0)
		except_end = Vector2i(12,5)
		
		
		
	elif tutorial_count == 2:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_2"], true)
		
		tutorial_label.set_position(Vector2(100,200))
		tutorial_label.text = "If the river reaches the bottom of the map (city limit), the city is broken.
							Your task is to delay the flood in the city so more people can escape from the city
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
			
		tutorial_label.set_position(Vector2(200,200))
		tutorial_label.text = "GAME OVER!!!"
		tutorial_label.add_theme_color_override("font_color",Color(1,0,0,1))
		tutorial_label.add_theme_font_size_override("font_size",50)
	
		
	elif tutorial_count == 3:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_3"], true)
		tutorial_label.set_position(Vector2(100,100))
		tutorial_label.text = 	"You can see your score, money, and mode on the right.
								The score and money increases as time goes on.
								You can change mode by using ASDF keys.
								These items are placable by spending money.
								Try to get higher score!"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
		
	elif tutorial_count == 5:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_4"], true)
		tutorial_label.set_position(Vector2(50,300))
		tutorial_label.text = "You can dig river to divert river direction
								You cannot make pond (4 tile square)
								If you are in different mode (undig, pump etc), press S to start digging.
								You need 5 money to dig"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(6,0)
		except_end = Vector2i(16,6)
		
	elif tutorial_count == 6:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_5"], true)
		tutorial_label.set_position(Vector2(50,300))
		tutorial_label.text =  "You can use pump to stop river from flowing
								Press D and place it on green (ground) tile next to river 
								If the house is flooded, you can place pump next to it to protect it
								You need 20 money to place it"
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
		tutorial_label.set_position(Vector2(50,300))
		tutorial_label.text = "You can use cistern to increase the power of pump
								Press F and place it on green (ground) tile next to pump 
								If house/car is flooded, you can place pump next to it to protect it
								You need 10 money to place it"
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
		tutorial_label.set_position(Vector2(150,50))
		tutorial_label.text = "You can undig the riverbed (brown tile) and river
								Undigging prevents river from flowing to certain direction
								You need another riverbed access to the bottom to undig
								You need 5 money to undig riverbed
								You need 10 money to dig shallow river
								You need 15 money to dig deep river"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(3,6)
		except_end = Vector2i(13,11)
		
		while true:
			#wait until the timer runs out of time (until river change state)
			await get_tree().create_timer(timer.wait_time).timeout
			tile_map.set_cell(LAYERS["ground"],Vector2i(3,6), 0, Vector2i(4,0))
			
	elif tutorial_count == 4:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_8"], true)
		tutorial_label.set_position(Vector2(150,50))
		tutorial_label.text = "You can see there are different tiles
								House/car tiles to protect 
								- If next to river tile, they will be flooded
								- If they are flooded/broken, you lose score
								Rock tile can be unchangeable
								The city at the bottom will be broken eventually...
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
		
	elif tutorial_count == 9:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_9"], true)
		tutorial_label.set_position(Vector2(100,200))
		tutorial_label.text = "Tutorial Completed!"
		tutorial_label.add_theme_color_override("font_color",Color(0.5,1,0.5,1))
		tutorial_label.add_theme_font_size_override("font_size",50)
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
	#set_outside_border()
	
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

extends Node2D

@onready var tile_map =  $"../TileMap"

@onready var timer = $"../TileMap/Timer"
@onready var gameover_timer = $"../TileMap/GameOverTimer"
@onready var flood_timer = $"../TileMap/FloodTimer"


var tutorial_label = Label.new()
var except_start = Vector2i(0,0)
var except_end = Vector2i(0,0)

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
		tutorial_label.set_position(Vector2(150,200))
		tutorial_label.text = "water flows toward dry riverbed"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(7,0)
		except_end = Vector2i(11,4)
		
		
		
	elif tutorial_count == 2:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_2"], true)
		
		tutorial_label.set_position(Vector2(100,200))
		tutorial_label.text = "if the river reaches the bottom of the map (city limit), the city is broken.
							Your task is to delay the flood in the city so more people can escape from the city
							If the river reaches the city..."
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(5,9)
		except_end = Vector2i(13,13)
		
		while not gameover_timer.is_stopped():
			
			#wait until the timer runs out of time (until river change state)
			await get_tree().create_timer(timer.wait_time).timeout
			#set deepest river at the top of the border of the tutorial2
			tile_map.set_cell(LAYERS["ground"], Vector2i(12, 8), 0, Vector2i(4,0))
			#tile_map.set_cell(LAYERS["ground"], Vector2i(8,10), 0, Vector2i(4,0))
			#if just_before_gameover state, pop out game over
			
		print("youve reached the end")
		tutorial_label.set_position(Vector2(200,200))
		tutorial_label.text = "GAME OVER!!!"
		tutorial_label.add_theme_color_override("font_color",Color(1,0,0,1))
		tutorial_label.add_theme_font_size_override("font_size",50)
	
		
	elif tutorial_count == 3:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_3"], true)
		tutorial_label.set_position(Vector2(150,200))
		tutorial_label.text = 	"you can see your score, money, and mode on the right.
								The score and money increases as time goes on.
								You can change mode by using ASDF keys.
								These items are placable by spending money.
								Try to get higher score!"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
		
	elif tutorial_count == 4:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_4"], true)
		tutorial_label.set_position(Vector2(150,200))
		tutorial_label.text = "if the river reaches the bottom of the map (city limit),\n the city is broken.\n your task is to delay the flood in the city\n so more people can escape from the city"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(7,0)
		except_end = Vector2i(13,6)
		
	elif tutorial_count == 5:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_5"], true)
		tutorial_label.set_position(Vector2(150,200))
		tutorial_label.text = "if the river reaches the bottom of the map (city limit),\n the city is broken.\n your task is to delay the flood in the city\n so more people can escape from the city"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(0,0)
		except_end = Vector2i(8,6)
		
		for y in range(0,6):
			tile_map.set_cell(LAYERS["ground"], Vector2i(8, y), 0, Vector2i(4,0))
		#tile_map.set_cell(LAYERS["ground"], Vector2i(8,4), 0, Vector2i(4,0))
		
	elif tutorial_count == 6:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_6"], true)
		tutorial_label.set_position(Vector2(150,200))
		tutorial_label.text = "if the river reaches the bottom of the map (city limit),\n the city is broken.\n your task is to delay the flood in the city\n so more people can escape from the city"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(0,3)
		except_end = Vector2i(4,7)
		
	elif tutorial_count == 7:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_7"], true)
		tutorial_label.set_position(Vector2(150,200))
		tutorial_label.text = "if the river reaches the bottom of the map (city limit),\n the city is broken.\n your task is to delay the flood in the city\n so more people can escape from the city"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(10,6)
		except_end = Vector2i(16,11)
		
	elif tutorial_count == 8:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_8"], true)
		tutorial_label.set_position(Vector2(150,200))
		tutorial_label.text = "if the river reaches the bottom of the map (city limit),\n the city is broken.\n your task is to delay the flood in the city\n so more people can escape from the city"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
		except_start = Vector2i(3,6)
		except_end = Vector2i(13,11)
		
	elif tutorial_count == 9:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_9"], true)
		tutorial_label.set_position(Vector2(150,200))
		tutorial_label.text = "if the river reaches the bottom of the map (city limit),\n the city is broken.\n your task is to delay the flood in the city\n so more people can escape from the city"
		tutorial_label.add_theme_color_override("font_color",Color(0,0,0,1))
		if tutorial_label not in get_children():
			add_child(tutorial_label)
			
	set_outside_border()
	
	
		
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
			#tile_map.set_cell(LAYERS["ground"], Vector2i(x, ey+2), 0, Vector2i(1,0))
			tile_map.set_cell(LAYERS["ground"], Vector2i(x, ey+1), 0, Vector2i(0,0))
		
	"""
	for y in range(-1, 13):
		tile_map.set_cell(LAYERS["ground"], Vector2i(sx-2, y), 0, Vector2i(1,0))
		tile_map.set_cell(LAYERS["ground"], Vector2i(ex+2, y), 0, Vector2i(1,0))
	"""
	
			
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
		
		var x = tile_mouse_pos[0]
		var y = tile_mouse_pos[1]
		
		if sx == ex and sy == ey:
			sx = 0
			ex = 30
			sy = 0
			ey = 20
	
		var within_area = sx <= x and x <= ex and sy <= y and y <= ey
		if not within_area:
			
			print(tile_mouse_pos, except_start, except_end, within_area)
			#get_viewport().set_input_as_handled()
			return
				
func _on_game_over_timer_timeout():
	var just_before_gameover = tile_map.get_cell_atlas_coords(LAYERS["flood"], Vector2i(1,12)) \
								== Vector2i(2,0)
	
	#print("not stopped")
	if just_before_gameover:
		gameover_timer.stop()
		flood_timer.stop()
		

func _on_timer_timeout():
	drain_all_water()

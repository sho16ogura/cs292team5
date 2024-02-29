extends Node2D

@onready var tile_map =  $"../TileMap"
var tutorial_mode = Global.tutorial
var tutorial_count = 0
var tutorial_label = Label.new()

const LAYERS = {
	"ground" : 0,
	"top" : 1,
	"flood" : 2,
	"highlight" : 3,
	"tutorial_border_0" : 4,
	"tutorial_border_1" : 5,
	"tutorial_border_2" : 6,
	"tutorial_border_3" : 7,
	"tutorial_border_4" : 8
}

func _ready():
	print(tutorial_mode)
	if tutorial_mode:
		#create quit tutorial button
		var quit_tutorial_button = Button.new()
		quit_tutorial_button.set_position(Vector2(100,450))
		quit_tutorial_button.text = "back to main menu"
		quit_tutorial_button.pressed.connect(self._on_quit_tutorial_button_pressed)
		add_child(quit_tutorial_button)
		
		#create next tutorial button
		var next_tutorial_button = Button.new()
		next_tutorial_button.set_position(Vector2(500,450))
		next_tutorial_button.text = "next"
		next_tutorial_button.pressed.connect(self._on_next_tutorial_button_pressed)
		add_child(next_tutorial_button)
		
		#create previous tutorial button
		var previous_tutorial_button = Button.new()
		previous_tutorial_button.set_position(Vector2(350,450))
		previous_tutorial_button.text = "back"
		previous_tutorial_button.pressed.connect(self._on_previous_tutorial_button_pressed)
		add_child(previous_tutorial_button)
		
	tile_map.set_cell(LAYERS["ground"], Vector2i())
		
func _on_previous_tutorial_button_pressed():
	tutorial_count_change(-1)
	do_tutorial()
	
		
func _on_next_tutorial_button_pressed():
	tutorial_count_change(1)
	do_tutorial()
	
func _on_quit_tutorial_button_pressed():
	print("quit tutorial")
	Global.switch_scene("res://main menu/main menu/main_menu.tscn")
	

func tutorial_count_change(dif):
	tutorial_count += dif
	if tutorial_count < 0:
		tutorial_count = 0
	
		
func do_tutorial():
	#print(tutorial_count)
	#unable all tutorial layer
	for i in range(4,8):
		tile_map.set_layer_enabled(i, false)
		
	if tutorial_count == 1:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_1"], true)
		#tutorial_label = Label.new()
		tutorial_label.set_position(Vector2(150,200))
		tutorial_label.text = "water flows from top to bottom"
		tutorial_label.add_theme_color_override("hello",Color(1, 1, 1, 1))
		add_child(tutorial_label)
		
		print(tutorial_label.text)
		drain_all_water()
		
	if tutorial_count == 2:
		tile_map.set_layer_enabled(LAYERS["tutorial_border_2"], true)
		
func drain_all_water():
	for x in range(17):
		for y in range(13):
			var is_water = tile_map.get_cell_atlas_coords(LAYERS["ground"], Vector2i(x,y))\
						 in [Vector2i(2,0), Vector2i(3,0), Vector2i(4,0)]
			#print(tile_map.get_cell_atlas_coords(LAYERS["ground"], Vector2i(x,y)))
			if is_water:
				#change to riverbed
				tile_map.set_cell(LAYERS["ground"], Vector2i(x,y), 0, Vector2i(1,0))
	
	

	


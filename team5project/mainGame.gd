extends Node2D

@onready var tile_map : TileMap = $TileMap
@onready var timer : Timer = $TileMap/Timer

var ground_layor = 0
#var top_layor = 1

var prevhover : Vector2i = Vector2i(0,0)

var global_lockout = false
var light_on_location = Vector2i(20, 10)

#returns tile category int (0 = no data, 1 = ground, 2 = riverbed, 3 = river, 4 = pump)
var tile_category_custom_data = "tile_category"

@onready var dig_undig_sfx = $TileMap/dig_undig_sfx
@onready var hammer_sfx = $TileMap/hammer_sfx
@onready var error_sfx = $TileMap/error_sfx
@onready var destruction_sfx = $TileMap/destruction_sfx
@onready var pumping_water_sfx = $TileMap/pumping_water_sfx
@onready var end_screen = $end_screen
@onready var tilemap = $TileMap

var num_pump_running = 0

enum MODES {DIG, UNDIG, PUMP, CISTERN}
var mode_state = MODES.DIG # by default, player can dig ground

enum COUNTER {MONEY, SCORE}
enum TILE {LAND, PUMP, CISTERN, RIVERBED, LOW_WATER, WATER, HIGH_WATER, LIGHT_ON, LIGHT_OFF}

#dictionary to make calling tile locations easier and clearer
var tile_dict = {
	#Game tiles
	TILE.LAND: Vector2i(0, 0),
	TILE.PUMP: Vector2i(0, 1),
	TILE.CISTERN: Vector2i(1, 1),
	TILE.RIVERBED: Vector2i(1, 0),
	TILE.LOW_WATER: Vector2i(2, 0),
	TILE.WATER: Vector2i(3, 0),
	TILE.HIGH_WATER: Vector2i(4, 0),
	TILE.LIGHT_ON: Vector2i(4, 3),
	TILE.LIGHT_OFF: Vector2i(4, 2),
	#Score counter tiles
	"0": Vector2i(0, 4),
	"1": Vector2i(1, 4),
	"2": Vector2i(2, 4),
	"3": Vector2i(3, 4),
	"4": Vector2i(4, 4),
	"5": Vector2i(0, 5),
	"6": Vector2i(1, 5),
	"7": Vector2i(2, 5),
	"8": Vector2i(3, 5),
	"9": Vector2i(4, 5)
}

#array of coordinates of neighbros (curr, right, down, left, up) if curr = (0,0)
const FOUR_NEIGHBOR_DIF = [Vector2i(0,0),Vector2i(1,0),Vector2i(0,1),Vector2i(-1,0),Vector2i(0,-1)]

#array of coordinates of neighbors (curr, right, rightdown down, downleft, left, leftup, up, upright) if curr = (0,0)
const EIGHT_NEIGHBOR_DIF = [Vector2i(0,0),Vector2i(1,0),Vector2i(1,1),Vector2i(0,1),
Vector2i(-1,1),Vector2i(-1,0),Vector2i(-1,-1),Vector2i(0,-1),Vector2i(1,-1)]

#start with 100 money and 0 score
var balance = 100
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass #no function needed here at the moment

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Go to Project Setting -> Physics -> Common to see number of cycles per second
func _process(_delta):
	pass 
	#no function needed here at the moment
	#add code to _on_timer_timeout for water pulse related events
	#add code to _on_pump_timer_timeout for pump pulse related events

func _input(event): 
	#if hovering mouse on a tile, highlight based on the tile
	if event is InputEventMouseMotion:
		#update prevhover (to delete previous highlight) and add highlight for current tile
		prevhover = highlight_tile(prevhover)
		
	#if toggle_dig (J) is pressed, mode change to dig mode
	if Input.is_action_just_pressed("toggle_dig"):
		mode_state = MODES.DIG
		print("dig mode")
		set_tile_type(light_on_location, TILE.LIGHT_OFF)
		set_tile_type(Vector2i(20, 10), TILE.LIGHT_ON)
		light_on_location = Vector2i(20, 10)
		temp_func()
	
	#if toggle_undig (K) is pressed, mode change to undig mode
	elif Input.is_action_just_pressed("toggle_undig"):
		mode_state = MODES.UNDIG
		print("undig mode")
		set_tile_type(light_on_location, TILE.LIGHT_OFF)
		set_tile_type(Vector2i(18, 10), TILE.LIGHT_ON)
		light_on_location = Vector2i(18, 10)
		temp_func()
	
	elif Input.is_action_just_pressed("toggle_pump"):
		mode_state = MODES.PUMP
		print("pump mode")
		set_tile_type(light_on_location, TILE.LIGHT_OFF)
		set_tile_type(Vector2i(22, 10), TILE.LIGHT_ON)
		light_on_location = Vector2i(22, 10)
		temp_func()

	elif Input.is_action_just_pressed("toggle_cistern"):
		mode_state = MODES.CISTERN
		print("cistern mode")
		set_tile_type(light_on_location, TILE.LIGHT_OFF)
		set_tile_type(Vector2i(24, 10), TILE.LIGHT_ON)
		light_on_location = Vector2i(24, 10)
		temp_func()
	
	elif event is InputEventMouseMotion:
		temp_func()
	
	#can add action by Project -> Project Settings -> Input Map -> Add new Action
	elif Input.is_action_just_pressed("click") and global_lockout == false: #if left mouse button is clicked
		#add constraint to each kind of tile by TileSet (on the right) 
		#-> Custom Data Layers (and add variable) -> paint (bottom)->paint properties
		#->painting on 
		
		var mouse_pos : Vector2i = get_global_mouse_position() #global position in float
		var tile_mouse_pos : Vector2i = tile_map.local_to_map(mouse_pos) #local position in int
		tile_mouse_pos = tile_mouse_pos + Vector2i(-1, -1)
		
		var eight_sur_tiles = get_eight_neighbor_category(tile_mouse_pos)
		var four_sur_tiles = get_four_neighbor_category(tile_mouse_pos)
		var source_id = 0
		
		if mode_state == MODES.DIG:
			var riverbed_atlas_coord = Vector2i(1, 0) #riverbed tile
			

			#if following conditions are met, set cell to riverbed
			if can_dig(eight_sur_tiles) and  check_and_reduce_balance(1):
				
				tile_map.set_cell(ground_layor, tile_mouse_pos, source_id, riverbed_atlas_coord) #set cell to riverbed 
				dig_undig_sfx.play(0.2) #sound effect starts
				
			else:
				error_sfx.play()
				print("cannot dig here")
				
		elif mode_state == MODES.UNDIG:
			var ground_atlas_coord = Vector2i(0,0) #ground tile
			
			if can_undig(eight_sur_tiles, tile_mouse_pos) and  check_and_reduce_balance(1):
				
				tile_map.set_cell(ground_layor, tile_mouse_pos, source_id, ground_atlas_coord)#change cell to ground
				dig_undig_sfx.play(0.2)#soundeffect
				
			else:
				error_sfx.play()
				print("cannot undig here")
		
		elif mode_state == MODES.PUMP:
			var pump_atlas_coord = Vector2i(0,1) #pump tile
			var ground_atlas_coord = Vector2i(0,0) #ground tile
			
			#set pump, iterate and change back to ground
			if can_place_pump(eight_sur_tiles) and  check_and_reduce_balance(5):
				
				#set pump
				tile_map.set_cell(ground_layor, tile_mouse_pos, source_id, pump_atlas_coord)
				hammer_sfx.play() #for construction
				
				num_pump_running += 1
				
				#remove surrounding river 10 times (pulses)
				for i in range(10):
					#wait until the timer runs out of time (until river change state)
					await get_tree().create_timer(2.0).timeout
					
					if not pumping_water_sfx.playing:
						pumping_water_sfx.play()
					
					#if cistern is located next to the pump, strenthen the pump
					var is_cistern_neighbor = four_sur_tiles.slice(1).any(func (c): return c==5)
			
					if is_cistern_neighbor:
						drain_eight_neighbor_river(tile_mouse_pos, source_id)
					else:
						drain_four_neighbor_river(tile_mouse_pos, source_id)
						
				num_pump_running -= 1
				
				if num_pump_running == 0:
					pumping_water_sfx.stop()
					
				destruction_sfx.play()
					
				#change back to ground
				tile_map.set_cell(ground_layor, tile_mouse_pos, source_id, ground_atlas_coord)
				
			else:
				error_sfx.play()
				print("cannot set pump here")
				
		elif mode_state == MODES.CISTERN:
			var cistern_atlas_coord = Vector2i(1,1) #cistern tile
			var ground_atlas_coord = Vector2i(0,0) #ground tile
			
			
			#set pump, iterate and change back to ground
			if can_place_cistern(eight_sur_tiles) and  check_and_reduce_balance(2):
				
				#set cistern
				tile_map.set_cell(ground_layor, tile_mouse_pos, source_id, cistern_atlas_coord)
				hammer_sfx.play()#constructing sound
			else:
				error_sfx.play()
				print("cannot set cistern here")
				
			
		else:
			error_sfx.play()
			print("not enough balance")
			
		
func highlight_tile(prev_hover):
	var mouse_pos : Vector2i = get_global_mouse_position() #global position in float
	var tile_mouse_pos : Vector2i = tile_map.local_to_map(mouse_pos) #local position in int
	tile_mouse_pos = tile_mouse_pos + Vector2i(-1, -1)
	
	var eight_sur_tiles = get_eight_neighbor_category(tile_mouse_pos)
	var four_sur_tiles = get_four_neighbor_category(tile_mouse_pos)
	var source_id = 1
	
	var highlight_layer = 2
	
	var highlight_cannot_set_coord = Vector2i(0,2) #red highlight tile
	var highlight_can_set_coord = Vector2i(2,2) #blue highlight tile
	
	#erase the highlight of the previous cell
	tile_map.set_cell(highlight_layer, prev_hover) 
	
	#if the mouse is in the range of (0,0) ~ (16,12) (inside the green tiles), hover
	if 0 <= tile_mouse_pos[0] and tile_mouse_pos[0] <= 16 and 0 <= tile_mouse_pos[1] and tile_mouse_pos[1] <= 12:
		
		if mode_state == MODES.DIG:
			if can_dig(eight_sur_tiles):
				#blue highlight
				tile_map.set_cell(highlight_layer, tile_mouse_pos, source_id, highlight_can_set_coord)
			
			else:	
				#red highlight
				tile_map.set_cell(highlight_layer, tile_mouse_pos, source_id, highlight_cannot_set_coord)
					
		elif mode_state == MODES.UNDIG:
			if can_undig(eight_sur_tiles, tile_mouse_pos):
				#blue highlight
				tile_map.set_cell(highlight_layer, tile_mouse_pos, source_id, highlight_can_set_coord)
			
			else:	
				#red highlight
				tile_map.set_cell(highlight_layer, tile_mouse_pos, source_id, highlight_cannot_set_coord)
				
		elif mode_state == MODES.PUMP:
			if can_place_pump(eight_sur_tiles):
				#blue highlight
				tile_map.set_cell(highlight_layer, tile_mouse_pos, source_id, highlight_can_set_coord)
			
			else:	
				#red highlight
				tile_map.set_cell(highlight_layer, tile_mouse_pos, source_id, highlight_cannot_set_coord)
				
		elif mode_state == MODES.CISTERN:
			if can_place_cistern(eight_sur_tiles):
				#blue highlight
				tile_map.set_cell(highlight_layer, tile_mouse_pos, source_id, highlight_can_set_coord)
			
			else:	
				#red highlight
				tile_map.set_cell(highlight_layer, tile_mouse_pos, source_id, highlight_cannot_set_coord)
			
	return tile_mouse_pos
		
	
func can_dig(eight_sur_tiles):

	#boolean variables for the following if statement
	var curr_tile_is_ground = eight_sur_tiles[0] == 1 
			
	#if surrounding tiles contain no_data (outside border), false
	var surr_tiles_are_not_outside = eight_sur_tiles.all(func(c): return c!=0)
			
	#if square of riverbed or river is made, false
	var will_not_make_riverbed_square = not will_be_riverbed_square(eight_sur_tiles)
	
	return curr_tile_is_ground and surr_tiles_are_not_outside and will_not_make_riverbed_square

func can_undig(eight_sur_tiles, tile_mouse_pos):
	
	#checks if the current tile is riverbed
	var curr_tile_is_riverbed = eight_sur_tiles[0] == 2
			
	#if surrounding tiles contain no_data (outside border), false
	var surr_tiles_are_not_outside = eight_sur_tiles.all(func(c): return c!=0)
	
	#checks the undig operation does not cut river connection
	var no_river_connection_loss = checkRiverConnection(tile_mouse_pos)
	
	return curr_tile_is_riverbed and surr_tiles_are_not_outside and no_river_connection_loss

func can_place_pump(eight_sur_tiles):
	
	var curr_tile_is_ground = eight_sur_tiles[0] == 1
			
	#if surrounding tiles contain no_data (outside border), false
	var surr_tiles_are_not_outside = eight_sur_tiles.all(func(c): return c!=0)
	
	return curr_tile_is_ground and surr_tiles_are_not_outside
			
	
func can_place_cistern(eight_sur_tiles):
	var curr_tile_is_ground = eight_sur_tiles[0] == 1
			
	#if surrounding tiles contain no_data (outside border), false
	var surr_tiles_are_not_outside = eight_sur_tiles.all(func(c): return c!=0)
			
	#create four neighboring tiles array based on eight neighboring tiles
	var four_sur_tiles = [eight_sur_tiles[0],eight_sur_tiles[1],eight_sur_tiles[3], eight_sur_tiles[5], eight_sur_tiles[7]]
	
	#if pump (to be strengthened) is located next to the cistern
	var is_pump_neighbor = four_sur_tiles.slice(1).any(func (c): return c==4)
	
	return curr_tile_is_ground and surr_tiles_are_not_outside and is_pump_neighbor
	
	
	
	
	
			
func will_be_riverbed_square(eight_sur_tiles):
	var right_up_square = eight_sur_tiles.slice(1,4).all(func(c): return c in [2,3])
	var right_down_square = eight_sur_tiles.slice(3,6).all(func(c): return c in [2,3])
	var left_down_square = eight_sur_tiles.slice(5,8).all(func(c): return c in [2,3])
	var left_up_square = eight_sur_tiles.slice(7).all(func(c): return c==2 or c==3) and eight_sur_tiles[1] in [2,3]
	return right_up_square or right_down_square or left_up_square or left_down_square
	
			
#check if balance exceeds specified fee and subtract
func check_and_reduce_balance(fee):
	if balance >= fee:
		balance -= fee
		update_counter(COUNTER.MONEY)
		return true
	
	return false

#inc money by 5 for each 30s
func _on_money_timer_timeout():
	balance += 5
	update_counter(COUNTER.MONEY)
	
func drain_four_neighbor_river(curr_pos, source_id):
	var four_sur_tiles = get_four_neighbor_category(curr_pos)
	
	for i in range(1,5):
		if four_sur_tiles[i] == 3:
			var neighbor_pos = curr_pos + FOUR_NEIGHBOR_DIF[i]
			var atlas_coord = Vector2i(1,0) #riverbed tile
			
			decrease_water_depth(neighbor_pos)

func drain_eight_neighbor_river(curr_pos, source_id):
	var eight_sur_tiles = get_eight_neighbor_category(curr_pos)
	
	#surtiles except for index 0 (current tile)
	for i in range(1,9):
		#if there is river tile in the neighbor, change it to riverbed
		if eight_sur_tiles[i] == 3:
			var neighbor_pos = curr_pos + EIGHT_NEIGHBOR_DIF[i]
			var atlas_coord = Vector2i(1,0) #riverbed tile
			
			decrease_water_depth(neighbor_pos)
			
func get_four_neighbor_category(curr_pos):
	var neighbor_tiles = [0,0,0,0,0]
	
	for i in range(5):
		var tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, curr_pos + FOUR_NEIGHBOR_DIF[i])
		if tile_data:
			neighbor_tiles[i] = tile_data.get_custom_data(tile_category_custom_data)
			
	return neighbor_tiles
	
#get category of surrounding tiles (0=nodata, 1=ground, 2=riverbed, 3=river, 4=pump)
func get_eight_neighbor_category(curr_pos):
	var neighbor_tiles = [0,0,0,0,0,0,0,0,0]
	
	#for each neighboring tiles (curr, right, rightdown, down, downleft, left, leftup, up, upright)
	for i in range(9):
		var tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, curr_pos + EIGHT_NEIGHBOR_DIF[i])
		if tile_data:
			neighbor_tiles[i] = tile_data.get_custom_data(tile_category_custom_data)
			
	return neighbor_tiles

#func get_score() -> int:
#	return score
	
# 2 second pulse, check water flow. order is down, left, then right. no support for water flowing up
func _on_timer_timeout():
	
	var tiles_flowed_to = {}
	
	if global_lockout == false:
		score += 10
		update_counter(COUNTER.SCORE)
	
	if check_tile(Vector2i(8, 0), is_river_not_high_water_tile):
		increase_water_depth(Vector2i(8, 0))
		if(check_tile(Vector2i(8, 0), is_high_water_tile)):
			tiles_flowed_to[Vector2i(8, 0)] = 1
	
	if check_tile(Vector2i(8, 0), is_high_water_tile) and check_tile(Vector2i(8, 1), is_river_not_high_water_tile):
		increase_water_depth(Vector2i(8, 1))
		if(check_tile(Vector2i(8, 1), is_high_water_tile)):
			tiles_flowed_to[Vector2i(8,1)] = 1
	
	if get_tile_type(Vector2i(8, 12)) == TILE.WATER and global_lockout == false:
		global_lockout = true
		print("game over!")
		end_screen.set_score(score - 10)
		end_screen.visible = true
		tilemap.visible = false
		print(score)
		#get_tree().change_scene_to_file("res://end screen/end_screen.tscn")
	
	for y in range(12, 0, -1):
		for x in range(16, 0 , -1):
			var temp_vec = Vector2i(x, y)
			if check_tile(temp_vec, is_high_water_tile) and tiles_flowed_to.has(temp_vec) == false:
				if check_neighbor(temp_vec, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE, is_river_not_high_water_tile):
					tiles_flowed_to.merge(water_flow(temp_vec, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE))
				elif check_neighbor(temp_vec, TileSet.CELL_NEIGHBOR_LEFT_SIDE, is_river_not_high_water_tile):
					tiles_flowed_to.merge(water_flow(temp_vec, TileSet.CELL_NEIGHBOR_LEFT_SIDE))
				elif check_neighbor(temp_vec, TileSet.CELL_NEIGHBOR_RIGHT_SIDE, is_river_not_high_water_tile): 
					tiles_flowed_to.merge(water_flow(temp_vec, TileSet.CELL_NEIGHBOR_RIGHT_SIDE))
				elif check_neighbor(temp_vec, TileSet.CELL_NEIGHBOR_TOP_SIDE, is_river_not_high_water_tile):
					tiles_flowed_to.merge(water_flow(temp_vec, TileSet.CELL_NEIGHBOR_TOP_SIDE))

#check if removing a tile from the river prevents there from being a continuous line of river tiles from the top to the bottom of the screen
func checkRiverConnection(tile_pos):

	var tiles_to_visit = {Vector2i(8,0): 1}
	var tiles_checked = {}
	
	while tiles_to_visit.is_empty() == false:
		
		var tile = tiles_to_visit.keys()[0]
		if tiles_checked.get(tile) or tile == tile_pos:
			tiles_to_visit.erase(tile)
			continue
		tiles_checked[tile] = 1
		
		if check_neighbor(tile, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE, is_river_tile):
			tiles_to_visit[tile_map.get_neighbor_cell(tile, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)] = 1
		if check_neighbor(tile, TileSet.CELL_NEIGHBOR_LEFT_SIDE, is_river_tile):
			tiles_to_visit[tile_map.get_neighbor_cell(tile, TileSet.CELL_NEIGHBOR_LEFT_SIDE)] = 1
		if check_neighbor(tile, TileSet.CELL_NEIGHBOR_RIGHT_SIDE, is_river_tile):
			tiles_to_visit[tile_map.get_neighbor_cell(tile, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)] = 1
		if check_neighbor(tile, TileSet.CELL_NEIGHBOR_TOP_SIDE, is_river_tile):
			tiles_to_visit[tile_map.get_neighbor_cell(tile, TileSet.CELL_NEIGHBOR_TOP_SIDE)] = 1
	
	if(tiles_checked.get(Vector2i(8, 12))):
		return true
	else: 
		return false

func update_counter(counter):
	if counter == COUNTER.MONEY:
		var counter_array = fix_counter_array_size(str(balance).split("", true))
		for x in 7:
			set_tile_type(Vector2i(x+18, 6), counter_array[x])
		return
	else: # COUNTER.SCORE
		var counter_array = fix_counter_array_size(str(score).split("", true))
		for x in 7:
			set_tile_type(Vector2i(x+18, 2), counter_array[x])
		return

func water_flow(tile, direction):
	var temp_dict = {}
	var neighbor = tile_map.get_neighbor_cell(tile, direction)
	
	decrease_water_depth(tile)
	increase_water_depth(neighbor)
	
	if check_tile(neighbor, is_high_water_tile):
		temp_dict[neighbor] = 1
	
	return temp_dict

func increase_water_depth(tile):
	if check_tile(tile, is_river_tile) == false:
		return
	elif check_tile(tile, is_riverbed_tile):
		set_tile_type(tile, TILE.LOW_WATER)
	elif check_tile(tile, is_low_water_tile):
		set_tile_type(tile, TILE.WATER)
	else:
		set_tile_type(tile, TILE.HIGH_WATER)

func decrease_water_depth(tile):
	if check_tile(tile, is_water_tile) == false:
		return
	elif check_tile(tile, is_high_water_tile):
		set_tile_type(tile, TILE.WATER)
	elif check_tile(tile, is_med_water_tile):
		set_tile_type(tile, TILE.LOW_WATER)
	else:
		set_tile_type(tile, TILE.RIVERBED)

func fix_counter_array_size(array):
	while array.size() < 7:
		array.insert(0, "0")
	while array.size() > 7:
		array.remove_at(0)
	return array

#returns the coordinates of the tile's sprite on the atlas
func get_tile_type(location):
	return tile_dict.find_key(tile_map.get_cell_atlas_coords(0, location))

#sets a tile at location to tile_type
func set_tile_type(location, tile_type):
	tile_map.set_cell(0, location, 0, tile_dict.get(tile_type))
	return

#Checks if the current tile is a river, riverbed, or water tile
func check_tile(tile, predicate):
	return predicate.call(get_tile_type(tile))

#Checks if a neighbor tile is a river, riverbed, or water tile
func check_neighbor(tile, direction, predicate):
	var neighbor = tile_map.get_neighbor_cell(tile, direction)
	return predicate.call(get_tile_type(neighbor))

#Checks if a tile is any river tile
func is_river_tile(tile):
	return tile == TILE.RIVERBED or tile == TILE.LOW_WATER or tile == TILE.WATER or tile == TILE.HIGH_WATER

#Checks if a tile is a water tile
func is_water_tile(tile):
	return tile == TILE.LOW_WATER or tile == TILE.WATER or tile == TILE.HIGH_WATER

#Checks if a tile is riverbed, low, or med water
func is_river_not_high_water_tile(tile):
	return tile == TILE.RIVERBED or tile == TILE.LOW_WATER or tile == TILE.WATER

#Checks if a tile is a med or high water tile
func is_med_or_high_water_tile(tile):
	return tile == TILE.WATER or tile == TILE.HIGH_WATER

#Checks if a tile is a low or med water tile
func is_low_or_med_water_tile(tile):
	return tile == TILE.LOW_WATER or tile == TILE.WATER

#Checks if a tile is a riverbed tile
func is_riverbed_tile(tile):
	return tile == TILE.RIVERBED

#Checks if a tile is low water
func is_low_water_tile(tile):
	return tile == TILE.LOW_WATER

#Checks if a tile is medium water
func is_med_water_tile(tile):
	return tile == TILE.WATER

#Checks if a tile is deep water
func is_high_water_tile(tile):
	return tile == TILE.HIGH_WATER

func temp_func():
	return

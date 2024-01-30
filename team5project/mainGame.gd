extends Node2D

@onready var tile_map : TileMap = $TileMap

var ground_layor = 0
#var top_layor = 1

var temp_count = 0



 #returns tile category int (0 = no data, 1 = ground, 2 = riverbed, 3 = river, 4 = pump)
var tile_category_custom_data = "tile_category"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	for i in range(13):
		
		var pos = Vector2i(8, i) #coordinate (8,i), which is all tiles in col 8 
		var source_id = 0
		var atlas_coord = Vector2i(1,0) #riverbed tile
		tile_map.set_cell(ground_layor, pos, source_id, atlas_coord) #place riverbed at the middle tiles
		
	
	var pos = Vector2i(8, 0) #coordinate (8,i), which is all tiles in col 8 
	var source_id = 0
	var atlas_coord = Vector2i(3, 0) #riverbed tile
	tile_map.set_cell(ground_layor, pos, source_id, atlas_coord) #place water at the top of middle column


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Go to Project Setting -> Physics -> Common to see number of cycles per second
func _process(delta):	
	
	pass #no function needed here at the moment, add code to _on_timer_timeout for pulse related events
	
func _input(event): 
	
	#can add action by Project -> Project Settings -> Input Map -> Add new Action
	if Input.is_action_just_pressed("click"): #if left mouse button is clicked
		
		#add constraint to each kind of tile by TileSet (on the right) 
		#-> Custom Data Layers (and add variable) -> paint (bottom)->paint properties
		#->painting on 
		
		
		var mouse_pos : Vector2i = get_global_mouse_position() #global position in float
		var tile_mouse_pos : Vector2i = tile_map.local_to_map(mouse_pos) #local position in int
		
		var source_id = 0
		var atlas_coord = Vector2i(1, 0) #riverbed tile
		
		var curr_tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, tile_mouse_pos) #get tile data (not the whole map)
		var right_tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, tile_mouse_pos + Vector2i(1,0)) #get the tile at the right side
		var rightdown_tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, tile_mouse_pos + Vector2i(1,1)) #get the tile at the rightdown side (diagonal)
		var down_tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, tile_mouse_pos + Vector2i(0,1)) #get the tile at the right side
		var downleft_tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, tile_mouse_pos + Vector2i(-1,1)) #get the tile at the downleft side (diagnoal
		var left_tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, tile_mouse_pos + Vector2i(-1,0)) #get the tile at the right side
		var leftup_tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, tile_mouse_pos + Vector2i(-1,-1)) #get the tile at the leftup side (diagnoal)
		var up_tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, tile_mouse_pos + Vector2i(0,-1)) #get the tile at the right side
		var upright_tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, tile_mouse_pos + Vector2i(1,-1)) #get the tile at the upright side (diagonal
		
		
		#category of surrounding tiles (curr, up, upright, right, rightdown, down, downleft, left, leftup)
		var sur_tiles = [0,0,0,0,0,0,0,0,0]
		
		if curr_tile_data:
			sur_tiles[0] = curr_tile_data.get_custom_data(tile_category_custom_data)
		
		
		if right_tile_data:
			sur_tiles[1] = right_tile_data.get_custom_data(tile_category_custom_data)
		if rightdown_tile_data:
			sur_tiles[2] = rightdown_tile_data.get_custom_data(tile_category_custom_data)
		if down_tile_data:
			sur_tiles[3] = down_tile_data.get_custom_data(tile_category_custom_data)
		if downleft_tile_data:
			sur_tiles[4] = downleft_tile_data.get_custom_data(tile_category_custom_data)
		if left_tile_data:
			sur_tiles[5] = left_tile_data.get_custom_data(tile_category_custom_data)
		if leftup_tile_data:
			sur_tiles[6] = leftup_tile_data.get_custom_data(tile_category_custom_data)
		if up_tile_data:
			sur_tiles[7] = up_tile_data.get_custom_data(tile_category_custom_data)
		if upright_tile_data:
			sur_tiles[8] = upright_tile_data.get_custom_data(tile_category_custom_data)
		
		var curr_tile_is_ground = sur_tiles[0] == 1 
		
		#if surrounding tiles contain riverbed or no_data (outside border), false
		var surr_tiles_are_not_river_or_outside = sur_tiles.all(func(c): return c!=0 and c!=3)
		
		#if place riverbed in curr_tile, can be square, false
		var will_not_make_riverbed_square = sur_tiles.slice(1,4).any(func(c): return c!=2) and \
			sur_tiles.slice(3,6).any(func(c): return c!=2) and  sur_tiles.slice(5,8).any(func(c): return c!=2) and \
			  (sur_tiles[1] != 2 or sur_tiles.slice(7).any(func(c): return c!=2)) 
		
		#print(sur_tiles, sur_tiles.slice(1,4).any(func(c): return c!=2),sur_tiles.slice(3,6).any(func(c): return c!=2),sur_tiles.slice(5,8).any(func(c): return c!=2),(sur_tiles[1] != 2 or sur_tiles.slice(7).any(func(c): return c!=2)) )
		
		#if following conditions are met, set cell to riverbed
		if curr_tile_is_ground and surr_tiles_are_not_river_or_outside and will_not_make_riverbed_square:
			tile_map.set_cell(ground_layor, tile_mouse_pos, source_id, atlas_coord) #set cell to riverbed 
			
		else:
			print("cannot place tile here")
	


func _on_timer_timeout():
	
	if tile_map.get_cell_atlas_coords(ground_layor, Vector2i(8, 0)) == Vector2i(1, 0):
		tile_map.set_cell(ground_layor, Vector2i(8,0), 0, Vector2i(3,0))
	elif tile_map.get_cell_atlas_coords(ground_layor, Vector2i(8, 0)) == Vector2i(3, 0):
		tile_map.set_cell(ground_layor, Vector2i(8,1), 0, Vector2i(3,0))
	
	for row in 15:
		for col in 11:
			var temp_vec = Vector2i(row + 1, col + 1)
			print(temp_vec)
			if tile_map.get_cell_atlas_coords(ground_layor, temp_vec) == Vector2i(3, 0):
				if tile_map.get_cell_altas_coords(ground_layor, tile_map.get_neighbor_cell(temp_vec, 4)) == Vector2i(1,0):
					tile_map.set_cell(ground_layor, tile_map.get_neighbor_cell(temp_vec, 4), 0, Vector2i(3,0))
				elif tile_map.get_cell_altas_coords(ground_layor, tile_map.get_neighbor_cell(temp_vec, 8)) == Vector2i(1,0):
					tile_map.set_cell(ground_layor, tile_map.get_neighbor_cell(temp_vec, 8), 0, Vector2i(3,0))
				elif tile_map.get_cell_altas_coords(ground_layor, tile_map.get_neighbor_cell(temp_vec, 0)) == Vector2i(1,0):
					tile_map.set_cell(ground_layor, tile_map.get_neighbor_cell(temp_vec, 0), 0, Vector2i(3,0))
	
	#var pos = Vector2i(8, temp_count/100) #temp_count is divided by 100 to make things slower
	#var source_id = 0
	#var atlas_coord = Vector2i(3, 0) #river tile
	#tile_map.set_cell(ground_layor, pos, source_id, atlas_coord) #place water from the top to bottom

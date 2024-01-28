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
	
	#print(temp_count)
	
	var pos = Vector2i(8, temp_count/100) #temp_count is divided by 100 to make things slower
	var source_id = 0
	var atlas_coord = Vector2i(3, 0) #river tile
	tile_map.set_cell(ground_layor, pos, source_id, atlas_coord) #place water from the top to bottom
	
	if temp_count < 1200:
		temp_count+=1
		
		
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
		var left_tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, tile_mouse_pos + Vector2i(-1,0)) #get the tile at the right side
		var up_tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, tile_mouse_pos + Vector2i(0,-1)) #get the tile at the right side
		var down_tile_data : TileData = tile_map.get_cell_tile_data(ground_layor, tile_mouse_pos + Vector2i(0,1)) #get the tile at the right side
		
		#category of surrounding tiles (curr, right, left, up, down)
		var sur_tiles = [0,0,0,0,0]
		
		if curr_tile_data:
			sur_tiles[0] = curr_tile_data.get_custom_data(tile_category_custom_data)
		if right_tile_data:
			sur_tiles[1] = right_tile_data.get_custom_data(tile_category_custom_data)
		if left_tile_data:
			sur_tiles[2] = left_tile_data.get_custom_data(tile_category_custom_data)
		if up_tile_data:
			sur_tiles[3] = up_tile_data.get_custom_data(tile_category_custom_data)
		if down_tile_data:
			sur_tiles[4] = down_tile_data.get_custom_data(tile_category_custom_data)
		
			
		print(sur_tiles.count(2))
		
		#if there is no no_data and river tile in neighbor and if no more than 2 riverbeds are around
		if sur_tiles[0] == 1 and sur_tiles.all(func(c): return c!=0 and c!=3) and sur_tiles.count(2)<2: 
			tile_map.set_cell(ground_layor, tile_mouse_pos, source_id, atlas_coord) #set cell to riverbed 
			
		else:
			print("cannot place tile here")
	

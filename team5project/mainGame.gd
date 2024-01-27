extends Node2D

@onready var tile_map : TileMap = $TileMap

var ground_layor = 0
var top_layor = 1


var temp_count = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	print("hello")
	
	for i in range(13):
		
		var pos = Vector2i(8, i) #coordinate (8,i), which is all tiles in col 8 
		var source_id = 0
		var atlas_coord = Vector2i(1,0) #riverbed tile
		tile_map.set_cell(top_layor, pos, source_id, atlas_coord) #place riverbed at the middle tiles
		
	
	var pos = Vector2i(8, 0) #coordinate (8,i), which is all tiles in col 8 
	var source_id = 0
	var atlas_coord = Vector2i(3, 0) #riverbed tile
	tile_map.set_cell(top_layor, pos, source_id, atlas_coord) #place water at the top of middle column


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Go to Project Setting -> Physics -> Common to see number of cycles per second
func _process(delta):	
	
	print(temp_count)
	
	var pos = Vector2i(8, temp_count/100) #temp_count is divided by 100 to make things slower
	var source_id = 0
	var atlas_coord = Vector2i(3, 0) #river tile
	tile_map.set_cell(top_layor, pos, source_id, atlas_coord) #place water from the top to bottom
	
	if temp_count < 1200:
		temp_count+=1
	
	

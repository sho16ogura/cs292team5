extends Node

var score = 0
var current_scene = null
var next_scene = null
var tutorial_count = -1
var hard_mode = 0
#enum COLORBLIND_MODE { None, Protanopia, Deuteranopia, Tritanopia, Achromatopsia }
#var current_mode = COLORBLIND_MODE.None

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)
	
func switch_scene_without_reset(res_path):
	if not next_scene:
		next_scene = current_scene
		current_scene.free()
		var s = load(res_path)
		current_scene = s.instantiate()
		
		get_tree().root.add_child(current_scene)
		get_tree().current_scene = current_scene
	else:
		var temp = current_scene
		current_scene.free()
		
		get_tree().root.add_child(next_scene)
		get_tree().current_scene = next_scene
		next_scene = temp
	
func _deferred_switch_scene(res_path):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
#referenc: https://www.youtube.com/watch?v=RMdf60IAxY0


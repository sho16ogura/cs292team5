extends Control

#@onready var settings_menu = $Settings_Menu as SettingsMenu
@onready var texture_reac = $TextureRect as TextureRect
#@onready var instruction_menu = $instruction_menu as InstructionMenu
@onready var grid_container = $GridContainer
@onready var tilemap = $"../TileMap"
var _is_paused: bool = false:
	set = set_paused

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused
	
func set_paused(value: bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused

func _on_resume_button_pressed() -> void:
	_is_paused = false
	if grid_container.visible == false:
		grid_container.visible = true
		tilemap.visible = true

#func _on_instruction_button_pressed() -> void:
#	instruction_menu.set_process(true)
#	instruction_menu.visible = true
#	texture_reac.visible = true
#	grid_container.visible = false

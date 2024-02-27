extends Control

@onready var settings_menu = $Settings_Menu as SettingsMenu
#@onready var texture_reac = $TextureRect as TextureRect

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

func _on_instruction_button_pressed() -> void:
	#settings_menu.set_process(true)
	#settings_menu.visible = true
	#texture_reac.visible = false
	pass

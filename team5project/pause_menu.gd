extends Control

@onready var settings_menu = $Settings_Menu as SettingsMenu
#@onready var texture_reac = $TextureRect as TextureRect
@onready var main_menu_button = $GridContainer/Main_Menu_Button as Button
var _is_paused: bool = false:
	set = set_paused

func _ready():
	handling_connecting_signals()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and Global.tutorial_count == -1:
		_is_paused = !_is_paused
	
func set_paused(value: bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused

func _on_resume_button_pressed() -> void:
	_is_paused = false

func on_main_menu_button_pressed() -> void:
	#settings_menu.set_process(true)
	#settings_menu.visible = true
	#texture_reac.visible = false
	_is_paused = !_is_paused
	Global.switch_scene("res://main menu/main menu/main_menu.tscn")
	#Global.tutorial_count = -1
	#Global.switch_scene("res://mainGame.tscn")
	#get_tree().change_scene_to_packed(start_level)
 
func handling_connecting_signals() -> void:
	main_menu_button.button_down.connect(on_main_menu_button_pressed)
	#pass

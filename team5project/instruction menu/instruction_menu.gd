class_name InstructionMenu
extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/Exit_Button
signal exit_settings_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)

func on_exit_pressed() -> void:
	#exit_settings_menu.emit()
	#set_process(false)
	get_tree().change_scene_to_file("res://pause menu/pause_menu.tscn")

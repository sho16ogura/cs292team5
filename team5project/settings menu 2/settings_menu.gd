class_name SettingsMenu2
extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/Exit_Button as Button

signal exit_settings_menu_2

func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)

func on_exit_pressed() -> void:
	exit_settings_menu_2.emit()
	set_process(false)

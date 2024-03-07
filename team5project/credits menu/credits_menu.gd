class_name CreditsMenu
extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/Exit_Button
# Called when the node enters the scene tree for the first time.
signal exit_credits_menu

func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)

func on_exit_pressed() -> void:
	exit_credits_menu.emit()
	set_process(false)

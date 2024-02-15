class_name EndScreen
extends Control

@onready var play_again_button = $MarginContainer/HBoxContainer/VBoxContainer/Play_Again_Button
@onready var main_menu_button = $MarginContainer/HBoxContainer/VBoxContainer/Main_Menu_Button
@onready var start_level = preload("res://mainGame.tscn") as PackedScene
@onready var main_menu = preload("res://main menu/main menu/main_menu.tscn") as PackedScene

func _ready():
	play_again_button.button_down.connect(on_start_pressed)
	main_menu_button.button_down.connect(main_menu_pressed)

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)

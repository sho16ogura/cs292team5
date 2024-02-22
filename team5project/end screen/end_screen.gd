class_name EndScreen
extends Control

#@onready var play_again_button = $MarginContainer/HBoxContainer/VBoxContainer/Play_Again_Button
@onready var main_menu_button = $MarginContainer/HBoxContainer/VBoxContainer/Main_Menu_Button
#@onready var start_level = preload("res://mainGame.tscn") as PackedScene
@onready var main_menu = preload("res://main menu/main menu/main_menu.tscn") as PackedScene
#@onready var main_menu = $Main_Menu
func _ready():
	#play_again_button.button_down.connect(on_start_pressed)
	main_menu_button.button_down.connect(main_menu_pressed)
	#var main_game_script = get_node("res://mainGame.gd")

#func on_start_pressed() -> void:
#	get_tree().change_scene_to_packed(start_level)

func set_score(score):
	#var script_main_menu = get_node("res://mainGame.gd")
	#var score_end = script_main_menu.score
	$MarginContainer/VBoxContainer/Score.text = "Score: " + str(score)

func main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)
	#main_menu.visible = true

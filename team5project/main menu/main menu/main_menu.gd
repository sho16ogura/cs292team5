class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var settings_button = $MarginContainer/HBoxContainer/VBoxContainer/Settings_Button as Button
#@onready var instruction_button = $MarginContainer/HBoxContainer/VBoxContainer/Instruction_Button as Button
#@onready var start_level = preload("res://mainGame.tscn") as PackedScene
@onready var settings_menu = $Settings_Menu as SettingsMenu
@onready var credits_menu = $Credits_Menu as CreditsMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var credits_button = $MarginContainer/HBoxContainer/VBoxContainer/Credits_Button as Button
@onready var settings_button_2 = $MarginContainer/HBoxContainer/VBoxContainer/Settings_Menu_Button as Button
@onready var settings_menu_2 = $Settings_Menu_2 as SettingsMenu2


func _ready():
	handling_connecting_signals()
	
func on_start_pressed() -> void:
	Global.tutorial = true
	Global.switch_scene("res://mainGame.tscn")
	#get_tree().change_scene_to_packed(start_level)

func on_exit_pressed() -> void:
	get_tree().quit()

func on_exit_settings_menu() -> void:
	margin_container.visible = true
	settings_menu.visible = false

func on_exit_credits_menu() -> void:
	margin_container.visible = true
	credits_menu.visible = false
	
func on_settings_pressed() -> void:
	margin_container.visible =  false
	settings_menu.set_process(true)
	settings_menu.visible = true

func on_credits_pressed() -> void:
	margin_container.visible =  false
	credits_menu.set_process(true)
	credits_menu.visible = true

func on_instruction_pressed() -> void:
	pass

func on_settings_menu2_pressed() -> void:
	margin_container.visible = false
	settings_menu_2.set_process(true)
	settings_menu_2.visible = true
	
func on_exit_settings_menu_2() -> void:
	margin_container.visible = true
	settings_menu_2.visible = false

func handling_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	settings_button.button_down.connect(on_settings_pressed)
	settings_button_2.button_down.connect(on_settings_menu2_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	credits_button.button_down.connect(on_credits_pressed)
	settings_menu.exit_settings_menu.connect(on_exit_settings_menu)
	credits_menu.exit_credits_menu.connect(on_exit_credits_menu)
	settings_menu_2.exit_settings_menu_2.connect(on_exit_settings_menu_2)

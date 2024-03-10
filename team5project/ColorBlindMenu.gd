extends Control

enum COLORBLIND_MODE { None, Protanopia, Deuteranopia, Tritanopia, Achromatopsia }

var option_button = OptionButton.new()

func _ready():
	# Add the OptionButton to the scene
	add_child(option_button)

	# Populate the OptionButton with the colorblind modes
	for mode in COLORBLIND_MODE.values():
		option_button.add_item(mode)

	# Connect the "item_selected" signal to a function
	option_button.connect("item_selected", self, "_on_OptionButton_item_selected")

func _on_OptionButton_item_selected(id):
	# Set the global colorblind mode to the selected mode
	Global.current_mode = COLORBLIND_MODE.values()[id]

extends StaticBody2D

var item = 1

# Put and assess price here
var item1price = 100
var item2price = 300

var item1owned = false
var item2owned = false

var price
# Called when the node enters the scene tree for the first time.
func _ready():
	$icon.play("pump")
	item = 1

func _physics_process(delta):
	if self.visible == true:
		if item == 1:
			$icon.play("pump")
		# ... put other items if finished

func _on_buttonleft_pressed():
	swap_item_back()
func _on_buttonright_pressed():
	swap_item_forward()
#func _on_buybutton_pressed():
#	if item == 1:
#		price = item1price
#		if Global.coins >= price:
#			if item1owned == false:
#				buy()
#	elif item == 2:
#		price = item2price
#		if Global.coins >= price:
#			if item2owned == false:
#				buy()

func swap_item_back():
	if item == 1:
		item = 2
	elif item == 2:
		item = 1
func swap_item_forward():
	if item == 1:
		item = 2
	if item == 2:
		item = 1

func buy():
	pass

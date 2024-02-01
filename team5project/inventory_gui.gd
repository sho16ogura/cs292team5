extends Control

var isOpen: bool = false
#@onready var inventory: Inventory = preload("res://inventory/playerInventory.tres")

#func _ready():
#	update()
	
#func update():
#	for i in range(min(inventory.items.size(), slots.size())):
#		slots[i].update(inventory.items[i])

#func update1():
#	for i in range(min(inventory.items.size(), slots.size())):
#		slots[i].update(inventory.items[i])

#func update2():
#	for i in range(min(inventory.items.size(), slots.size())):
#		slots[i].update(inventory.items[i])
func open():
	visible = true
	isOpen = true

func close():
	visible = false
	isOpen = false

func close1():
	visible = false
	isOpen = false

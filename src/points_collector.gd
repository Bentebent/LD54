extends Node

signal item_placed
signal item_removed

const list_one = preload("res://prefabs/packing_lists/list_one.tres")


func _ready():
	item_placed.connect(_item_placed)
	item_removed.connect(_item_removed)

	print(list_one.get_packing_list_collection())


func _generate_goals():
	pass


func _item_placed(item):
	print(item.pickupable.tags)

func _item_removed(item):
	print(item.pickupable.tags)
extends Node

signal item_placed
signal item_removed


func _ready():
	item_placed.connect(_item_placed)
	item_removed.connect(_item_removed)


func _item_placed(item):
	print(item)

func _item_removed(item):
	print(item)
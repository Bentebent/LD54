extends Node

signal item_placed
signal item_removed

const list_one = preload("res://prefabs/packing_lists/list_one.tres")

var active_list = []

class ListItem:
	var placed: bool = false
	var tags = []

	func _init(_tags):
		tags = _tags

	func _to_string():
		return str("Placed: ", placed, " ", "Tags: ", tags)

func _ready():
	item_placed.connect(_item_placed)
	item_removed.connect(_item_removed)

	_generate_goals(list_one)

	print(active_list)


func _generate_goals(selected_list):
	active_list = []
	for tag_list in selected_list.get_packing_list_collection():
		var list_item: ListItem = ListItem.new(tag_list)
		active_list.append(list_item)

func _item_placed(item):
	print(item.pickupable.tags)

func _item_removed(item):
	print(item.pickupable.tags)
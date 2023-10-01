extends Node

signal item_placed
signal item_removed

const list_one = preload("res://prefabs/packing_lists/list_one.tres")
var active_list = []

class ListItem:
	var items = {}
	var tags = []

	func _init(_tags):
		tags = _tags

	func _to_string():
		return str("Items: ", items, " ", "Tags: ", tags)

func _ready():
	item_placed.connect(_item_placed)
	item_removed.connect(_item_removed)

	_generate_goals(list_one)


func _generate_goals(selected_list):
	active_list = []
	for tag_list in selected_list.get_packing_list_collection():
		var list_item: ListItem = ListItem.new(tag_list)
		active_list.append(list_item)

func _item_placed(item):
	print("Item tags", item.tags)
	for list_item in active_list:
		if list_item.tags.size() <= item.tags.size():
			var intersecting = true
			for list_item_tag in list_item.tags:
				if not item.tags.has(list_item_tag):
					intersecting = false
					break
			if intersecting:
				list_item.items[item] = item

	print(active_list)

func _item_removed(item):
	for list_item in active_list:
		list_item.items.erase(item)

	print(active_list)

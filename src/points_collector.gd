extends Node

signal item_placed
signal item_removed
signal list_created
signal item_checked
signal scene_loaded

var list_one = load("res://prefabs/packing_lists/real_list_exe.tres") #load("res://prefabs/packing_lists/list_one.tres")
const PickupableTags = preload("res://src/pickupable_tags.gd").PickupableTags

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
	scene_loaded.connect(init)

func init():
	_generate_goals(list_one)

func _generate_goals(selected_list):
	active_list = []
	for tag_list in selected_list.get_packing_list_collection():
		var list_item: ListItem = ListItem.new(tag_list)
		active_list.append(list_item)
	
	print(active_list)
	var items = []
	for x in active_list:
		items.append(array_join(x.tags, ", "))

	list_created.emit(items)

func _update_checklist():
	var index: int = 0
	for list_item in active_list:
		item_checked.emit(index, list_item.items.size() > 0)
		index += 1

func _item_placed(item):
	for list_item in active_list:
		if list_item.tags.size() <= item.tags.size():
			var intersecting = true
			for list_item_tag in list_item.tags:
				if not item.tags.has(list_item_tag):
					intersecting = false
					break
			if intersecting:
				list_item.items[item] = item

	_update_checklist()

func _item_removed(item):
	for list_item in active_list:
		if list_item.items.erase(item):
			pass
		
	_update_checklist()

func array_join(arr : Array, glue : String = '') -> String:
	var string : String = ''
	for index in range(0, arr.size()):
		var enum_val: int = arr[index]
		string += str(PickupableTags.keys()[PickupableTags.values().find(enum_val)]) #str(PickupableTags.keys().find())
		if index < arr.size() - 1:
			string += glue
	return string

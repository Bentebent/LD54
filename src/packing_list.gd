extends Resource
class_name PackingList

const PickupableTags = preload("res://src/pickupable_tags.gd").PickupableTags

@export var tag_collection_len: Array[int] = []
@export var packing_list: Array[PickupableTags] = []
    
func get_packing_list_collection():
    
    var res = []
    var temp_list = packing_list.duplicate()
    var index: int = 0
    for tag_count_per_item in tag_collection_len:
        res.append([])
        for i in tag_count_per_item:
            res[index].append(temp_list.pop_front())
        
        index += 1
    return res


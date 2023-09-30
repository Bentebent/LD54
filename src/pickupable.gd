extends Resource
class_name Pickupable

enum PickupableTags{
	# Colors
	Black = 0,
	White,
	Red,
	Green,
	Blue,
	Brown,
	Purple,
	Yellow,
	
	# Size
	Small = 100,
	Big,
	
	# Utility
	Hygiene = 200,
	Clothing,
	Food,
	
	# Traits
	Curved = 300,
}

## Ascii map of the shape in the grid. Each row represents the x axis, and each column represents the z axis.[br]
## Example representing a "T" shaped object:[br]
## 111[br]
## 010[br]
## 010[br]
@export_multiline var grid_shape = ""

## Array containing all mesh variations of this pickupable.
@export var mesh_templates: Array[Mesh]

## Array containing tags specific to each mesh, used for color variations.
## Element 0 in this array represents element 0 in mesh_templates and so on.
@export var mesh_tags: Array[PickupableTags]

## Tags that affect all variations of this pickupable.
@export var tags: Array[PickupableTags]

var rng = RandomNumberGenerator.new()

class PickupableInstance:
	var mesh: Mesh
	var tags: Array[PickupableTags]

func get_random():
	var mesh_template_index = rng.randi_range(0, mesh_templates.size() - 1)
	var instance = PickupableInstance.new()
	instance.mesh = mesh_templates[mesh_template_index]
	instance.tags = tags.duplicate()
	instance.tags.append(mesh_tags[mesh_template_index])
	
	return instance
	

extends Node3D
class_name PackingGrid

@export var grid_dimensions : Vector3 = Vector3.ZERO
@export var cell_size: Vector3 = Vector3.ZERO

var cell_scene = preload("res://prefabs/packing_cell.tscn")
var grid = []
func _ready():
	for x in grid_dimensions.x:
		grid.append([])
		for y in grid_dimensions.y:
			for z in grid_dimensions.z:
				var instance = cell_scene.instantiate()
				instance.scale = cell_size
				instance.position = position + cell_size *  Vector3(x, y, z)
				add_child(instance)
				grid[x].append(0)
				instance.x = x
				instance.z = z
				#grid[x][z] = 0


func check_if_room(placeable, origin_tile):
	print(placeable)
	print(origin_tile)


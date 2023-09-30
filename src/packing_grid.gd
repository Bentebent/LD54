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
	var x = origin_tile.x
	var z = origin_tile.z
	var per_row_split = placeable.pickupable.grid_shape.split("\n")

	var failed = false
	for row in per_row_split:
		for column in row:
			if column == "1" and grid[x][z] == 1:
				failed = true
				break
			x += 1
		if failed:
			break
		z += 1
		x = origin_tile.x

	print(failed)
	#print(placeable.pickupable.grid_shape)

	#print()
	#print(origin_tile.x)
	#print(origin_tile.z)


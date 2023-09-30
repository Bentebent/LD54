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


func rotate_array(arr,count):
	for _c in range(count):
		var new_arr = []
		for i in range(len(arr[0])):
			var row = []
			for j in range(len(arr)):
				row.append(arr[len(arr) - j - 1][i])
			new_arr.append(row)
		arr=new_arr
	return arr

func check_if_room(placeable, origin_tile):
	var x = origin_tile.x
	var z = origin_tile.z
	var per_row_split = placeable.pickupable.grid_shape.split("\n")
	
	var collision_shape = []
	var i = 0
	for row in per_row_split:
		collision_shape.append([])
		for column in row:
			collision_shape[i].append(column)
		i += 1

	var rotated_shape = rotate_array(collision_shape, placeable.grid_orientation)

	if x + rotated_shape.size() > grid.size():
		return false
	if z + rotated_shape[0].size() > grid[0].size():
		return false

	var failed = false
	for row in rotated_shape:
		for column in row:
			if column == "1" and grid[x][z] == 1:
				failed = true
				break
			x += 1
		if failed:
			break
		z += 1
		x = origin_tile.x
	
	x = origin_tile.x
	z = origin_tile.z
	if !failed:
		for row in rotated_shape:
			for column in row:
				if column == "1":
					grid[x][z] = 1
				x += 1
			z += 1
			x = origin_tile.x

		placeable.grid_cell = origin_tile

	return !failed
	



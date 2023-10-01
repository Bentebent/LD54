extends Node3D
class_name PackingGrid

const debug_material = preload("res://materials/debug.tres")
@export var grid_dimensions : Vector3 = Vector3.ZERO
const cell_size: Vector3 = Vector3(0.2, 0.1, 0.2)

var cell_scene = preload("res://prefabs/packing_cell.tscn")
var grid = []
var grid_cells = []
func _ready():
	for x in grid_dimensions.x:
		grid.append([])
		grid_cells.append([])
		for y in grid_dimensions.y:
			for z in grid_dimensions.z:
				var instance = cell_scene.instantiate()
				instance.scale = cell_size
				instance.position = position + cell_size *  Vector3(x, y, z)
				add_child(instance)
				grid[x].append(0)
				grid_cells[x].append(instance)
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


func remove_placeable(placeable):
	var origin_tile = placeable.grid_cell
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


	var origin_x = x
	var origin_z = z
	
	if placeable.grid_orientation == 1:
		origin_x -= rotated_shape[0].size() - 1

	if placeable.grid_orientation == 2:
		origin_x -= rotated_shape[0].size() - 1
		origin_z -= rotated_shape.size() - 1

	if placeable.grid_orientation == 3:
		origin_z -= rotated_shape.size() - 1

	x = origin_x
	z = origin_z
	for row in rotated_shape:
		for column in row:
			if column == "1":
				grid[x][z] = 0
				# grid_cells[x][z].find_child("MeshInstance3D").material_override = null
			x += 1
		z += 1
		x = origin_x


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

	# print(rotated_shape)

	var origin_x = x
	var origin_z = z
	
	if placeable.grid_orientation == 1:
		origin_x -= rotated_shape[0].size() - 1

	if placeable.grid_orientation == 2:
		origin_x -= rotated_shape[0].size() - 1
		origin_z -= rotated_shape.size() - 1

	if placeable.grid_orientation == 3:
		origin_z -= rotated_shape.size() - 1

	print(placeable.grid_orientation)

	if origin_x < 0 || origin_x + rotated_shape[0].size() - 1 >= grid.size():
		print("x out")
		return false

	if origin_z < 0 || origin_z + rotated_shape.size() - 1 >= grid[0].size():
		print("z out")
		return false
	
	var failed = false
	x = origin_x
	z = origin_z
	for row in rotated_shape:
		for column in row:
			if column == "1" and grid[x][z] == 1:
				failed = true
				break
			x += 1
		if failed:
			break
		z += 1
		x = origin_x
	
	x = origin_x
	z = origin_z
	if !failed:
		for row in rotated_shape:
			for column in row:
				if column == "1":
					grid[x][z] = 1
					# grid_cells[x][z].find_child("MeshInstance3D").material_override = debug_material
				x += 1
			z += 1
			x = origin_x
		
		placeable.grid_cell = origin_tile

	return !failed
	



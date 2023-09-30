extends Node3D

@export var grid_dimensions : Vector3 = Vector3.ZERO
@export var cell_size: Vector3 = Vector3.ZERO

var cell_scene = preload("res://prefabs/packing_cell.tscn")

func _ready():
	for x in grid_dimensions.x:
		for y in grid_dimensions.y:
			for z in grid_dimensions.z:
				var instance = cell_scene.instantiate()
				instance.scale = cell_size
				instance.position = position + cell_size *  Vector3(x, y, z)
				add_child(instance)


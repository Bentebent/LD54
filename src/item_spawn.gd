extends Node3D
class_name ItemSpawn

const glow_material = preload("res://materials/glow_mat.tres")

@export var pickupable: Pickupable

@onready var meshInstance: MeshInstance3D = $Mesh
@onready var collisionShape: CollisionShape3D = $CollisionShape3D

var grid_orientation: int = 0
var grid_cell: PackingCell = null

func rotate_me(cw):
	if cw:
		rotate_y(-deg_to_rad(90))
		grid_orientation += 1
	else:
		rotate_y(deg_to_rad(90))
		grid_orientation -= 1

	grid_orientation = wrapi(grid_orientation, 0, 4)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var instance = pickupable.get_random()
	meshInstance.mesh = instance.mesh
	collisionShape.shape = meshInstance.mesh.create_convex_shape()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_glowing(is_glowing):
	if (is_glowing):
		meshInstance.material_override = glow_material
	else:
		meshInstance.material_override = null
	

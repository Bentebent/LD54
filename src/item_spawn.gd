extends Node3D
class_name ItemSpawn

@export var pickupable: Pickupable

@onready var meshInstance: MeshInstance3D = $Mesh
@onready var collisionShape: CollisionShape3D = $CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var instance = pickupable.get_random()
	meshInstance.mesh = instance.mesh
	collisionShape.shape = meshInstance.mesh.create_convex_shape()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

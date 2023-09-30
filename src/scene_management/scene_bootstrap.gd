extends Node3D
class_name SceneBootstrap

@export var initial_scene: PackedScene

var current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	switch_scene(initial_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_scene_change_requested(scene):
	switch_scene(load(scene))

func switch_scene(new_scene: PackedScene):
	if current_scene:
		current_scene.queue_free()
	
	current_scene = new_scene.instantiate()
	current_scene.scene_change_requested.connect(on_scene_change_requested)
	add_child(current_scene)

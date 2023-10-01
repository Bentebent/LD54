extends CharacterBody3D

@export var speed = 0
@export var accel = 50
@export var sensitivity = 0.001
@export var grab_dist = 3.0
@export var audio_collection = preload("res://prefabs/player_audio_collection.tres")
@onready var camera : CameraController = $"Camera/Camera3D"
@onready var hand : Node3D = $"Camera/Camera3D/Hand"
@onready var game_scene : GameScene = $".."
@onready var audio_player: AudioStreamPlayer3D = $"AudioStreamPlayer3D"



var target_velocity = Vector3.ZERO
var picked_up_item = null
var hovered_item = null
var placing_item = false
var grid_owner: PackingGrid = null
var grid_cell: PackingCell = null

func set_collisions_enabled(node, enabled):
	if enabled:
		if node.has_meta("col_mask"):
			node.collision_mask = node.get_meta("col_mask")
			node.collision_layer = node.get_meta("col_layer")
	else:
			node.set_meta("col_mask", node.collision_mask)
			node.set_meta("col_layer", node.collision_layer)
			node.collision_mask = 0
			node.collision_layer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _get_hovered_collider():
	var space_state = get_world_3d().direct_space_state
	var from = camera.global_position
	var to = from - camera.global_transform.basis.z * grab_dist
	var mask = 1 << 1
	var pickupableQuery = PhysicsRayQueryParameters3D.create(from, to, mask)
	var result = space_state.intersect_ray(pickupableQuery)
		
	if result:
		return result.get("collider")
	else:
		return null

func _pickup():
	var hovered_collider = _get_hovered_collider()
	if (hovered_collider):
		if picked_up_item != null:
			_drop()
		
		picked_up_item = hovered_collider
		picked_up_item.get_parent().remove_child(picked_up_item)
		picked_up_item.position = hand.position
		picked_up_item.rotation = Quaternion.IDENTITY.get_euler()
		#picked_up_item.rotate_y(deg_to_rad(180))
		hand.add_child(picked_up_item)

		if picked_up_item.grid_cell:
			picked_up_item.grid_cell.get_parent().remove_placeable(picked_up_item)
			picked_up_item.grid_cell = null
			picked_up_item.grid_orientation = 0

			PointsCollector.item_removed.emit(picked_up_item)
		
		set_collisions_enabled(picked_up_item, false)
		picked_up_item.freeze = true
		picked_up_item.sleeping = true


func _drop():
	if picked_up_item == null:
		return

	hand.remove_child(picked_up_item)
	
	get_tree().root.get_child(0).add_child(picked_up_item)
	picked_up_item.position = hand.global_position
	picked_up_item.freeze = false
	picked_up_item.sleeping = false
	set_collisions_enabled(picked_up_item, true)

	picked_up_item.apply_impulse(-camera.global_transform.basis.z *2)
	picked_up_item = null
	
	audio_player.stream = audio_collection.yells[0]
	audio_player.play()

func _place_item():
	if picked_up_item == null:
		return
	
	var space_state = get_world_3d().direct_space_state
	var from = camera.global_position
	var to = from - camera.global_transform.basis.z * grab_dist * 2
	var mask = 1 << 2
	var pickupableQuery = PhysicsRayQueryParameters3D.create(from, to, mask)
	var result = space_state.intersect_ray(pickupableQuery)
	if result:
		var other_collider = result.get("collider")
		if not placing_item:
			hand.remove_child(picked_up_item)
			get_tree().root.add_child(picked_up_item)
		picked_up_item.global_position = other_collider.global_position
		placing_item = true
		print(other_collider)
		grid_owner = other_collider.get_parent()
		grid_cell = other_collider
	else:
		picked_up_item.global_position = hand.global_position

		if placing_item:
			get_tree().root.remove_child(picked_up_item)
			hand.add_child(picked_up_item)

		picked_up_item.grid_orientation = 0
		placing_item = false
		grid_owner = null
		grid_cell = null

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera.rotate_me(event.relative, sensitivity)
		rotate_y(-event.relative.x * sensitivity)


func _physics_process(delta):
	if Input.is_action_just_pressed("exit"):
		game_scene.request_main_menu()


	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction += global_transform.basis.x
	if Input.is_action_pressed("move_left"):
		direction -= global_transform.basis.x
	if Input.is_action_pressed("move_bwd"):
		direction += global_transform.basis.z
	if Input.is_action_pressed("move_fwd"):
		direction -= global_transform.basis.z

	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	target_velocity.x = direction.x  * speed
	target_velocity.z = direction.z *  speed

	velocity = velocity.move_toward(target_velocity, delta * accel)
	move_and_slide()
	
	_place_item()

	if placing_item:
		if Input.is_action_just_pressed("rotate_cw"):
			#picked_up_item.rotate_y(-deg_to_rad(90))
			picked_up_item.rotate_me(true)
		if Input.is_action_just_pressed("rotate_ccw"):
			#picked_up_item.rotate_y(deg_to_rad(90))
			picked_up_item.rotate_me(false)

		if Input.is_action_just_pressed("left_click"):
			if grid_owner.check_if_room(picked_up_item, grid_cell):
				PointsCollector.item_placed.emit(picked_up_item)
				set_collisions_enabled(picked_up_item, true)
				placing_item = false
				picked_up_item = null
	else:
		if Input.is_action_just_pressed("left_click"):
			_pickup()
	
		if Input.is_action_just_pressed("right_click"):
			_drop()
	
	var new_hovered_item
	if (picked_up_item):
		new_hovered_item = null
	else:
		new_hovered_item = _get_hovered_collider()
		
	if (new_hovered_item != hovered_item):
		if (hovered_item):
			hovered_item.set_glowing(false)
		if (new_hovered_item):
			new_hovered_item.set_glowing(true)
		hovered_item = new_hovered_item

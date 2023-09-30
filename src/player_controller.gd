extends CharacterBody3D

@export var speed = 0
@export var sensitivity = 0.02
@export var grab_dist = 2.0

@onready var camera : CameraController = $"Camera/Camera3D"
@onready var hand : Node3D = $"Camera/Camera3D/Hand"

var target_velocity = Vector3.ZERO
var picked_up_item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _pickup():
	var space_state = get_world_3d().direct_space_state
	var from = camera.global_position
	var to = -camera.global_transform.basis.z * grab_dist
	var mask = 1 << 1
	var pickupableQuery = PhysicsRayQueryParameters3D.create(from, to, mask)
	var result = space_state.intersect_ray(pickupableQuery)
	
	if result:
		if picked_up_item != null:
			_drop()

		picked_up_item = result.get("collider")
		picked_up_item.get_parent().remove_child(picked_up_item)
		picked_up_item.position = hand.position
		hand.add_child(picked_up_item)
		picked_up_item.freeze = true


func _drop():
	if picked_up_item != null:

		hand.remove_child(picked_up_item)
		
		get_tree().root.get_child(0).add_child(picked_up_item)
		picked_up_item.position = hand.global_position
		picked_up_item.freeze = false
		picked_up_item = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera.rotate_me(event.relative, sensitivity)
		rotate_y(-event.relative.x * sensitivity)


func _physics_process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()


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

	velocity = target_velocity
	move_and_slide()

	if Input.is_action_just_pressed("left_click"):
		_pickup()

	if Input.is_action_just_pressed("right_click"):
		_drop()
	
	# Ray cast for checking pickupables
	


		

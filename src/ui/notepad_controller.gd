extends Control

const visible_position = Vector2(0, 0)
const hidden_position = Vector2(512, 0)
const animation_speed = 1.5

@onready var todo_list_wrapper: Control = $todo_list_wrapper
@onready var open_todo_tutorial_text: Control = $open_notepad_tutorial_text

var notepad_visible = false
var notepad_visible_t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("open_notepad")):
		notepad_visible = !notepad_visible
	
	
	var target_t = 1 if notepad_visible else 0
	notepad_visible_t = move_toward(notepad_visible_t, target_t, animation_speed * delta)
	var eased_t = ease(notepad_visible_t, -2.2)
	todo_list_wrapper.position = lerp(hidden_position, visible_position, eased_t)
	todo_list_wrapper.rotation = lerp(-0.5, 0.1, eased_t)
	
	if (open_todo_tutorial_text.visible):
		open_todo_tutorial_text.self_modulate.a = 1 - notepad_visible_t
		
		var time = Time.get_ticks_msec() / 1000.0
		open_todo_tutorial_text.position.y = -10 * abs(sin(PI * time))
	
	if (notepad_visible_t >= 1):
		open_todo_tutorial_text.visible = false

extends Control
class_name NotepadController

const visible_position = Vector2(0, 0)
const hidden_position = Vector2(512, 0)
const animation_speed = 1.5

@onready var todo_list_wrapper: Control = $todo_list_wrapper
@onready var open_todo_tutorial_text: Control = $open_notepad_tutorial_text
@onready var element_list_vertical_container: Control = $todo_list_wrapper/todo_list/VBoxContainer
@onready var slide_player = $slide
@onready var scribble_player = $scribble
@onready var scratch = $scratch

var notepad_visible = false
var notepad_visible_t = 0
	
func _init():
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	#PointsCollector.list_created.emit(["poo"])
	PointsCollector.list_created.connect(set_todo_list)
	PointsCollector.item_checked.connect(set_checked)
	PointsCollector.scene_loaded.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("open_notepad")):
		notepad_visible = !notepad_visible
		slide_player.play()
	
	
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


const _todo_list_element_scene = preload("res://prefabs/ui/todo_list_element.tscn")
var _todo_list: Array[RichTextLabel]
var _todo_list_strings: Array[String]

func set_todo_list(items):
	# remove all previous elements in vertical list
	for node in element_list_vertical_container.get_children():
		node.queue_free()
	
	_todo_list.clear()
	_todo_list_strings.clear()
	
	# add new items
	for item in items:
		var instance: RichTextLabel = _todo_list_element_scene.instantiate()
		instance.text = item
		element_list_vertical_container.add_child(instance)
		_todo_list.append(instance)
		_todo_list_strings.append(item)

const strikethrough_format = "[s]%s[/s]"
func set_checked(item_index: int, is_checked: bool = true):
	if is_checked and !scribble_player.playing:
		scribble_player.play()
	elif !is_checked and !scribble_player.playing and !scratch.playing:
		scratch.play()

	if (_todo_list.size() > 0 and item_index < _todo_list.size() and _todo_list_strings.size() > 0 and item_index < _todo_list_strings.size()):
		var item_text = _todo_list_strings[item_index]
		if (is_checked):
			item_text = strikethrough_format % item_text
		_todo_list[item_index].text = item_text

extends Node3D

@onready var game_scene : GameScene = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_yes_button_pressed():
	game_scene.request_game()


func _on_no_button_pressed():
	game_scene.request_exit_game()

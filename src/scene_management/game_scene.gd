extends Node3D
class_name GameScene

signal scene_change_requested(new_scene: PackedScene)

func request_exit_game():
	scene_change_requested.emit("res://scenes/exit_game.tscn")

func request_main_menu():
	scene_change_requested.emit("res://scenes/main_menu.tscn")

func request_game():
	scene_change_requested.emit("res://scenes/hello_scene.tscn")

extends Node

signal scene_change(scene: PackedScene)

@onready var current_scene: PackedScene = preload("res://scenes/main/levels/ship.tscn")
@onready var scene_transition = preload("res://scenes/common/scene_transition_ui.tscn")

var current_tilemap: TileMap
var camera_limits
var next_scene: PackedScene

func load_new_scene(scene: PackedScene) -> void:
	next_scene = scene
	var transition = scene_transition.instantiate()
	var ui = get_tree().get_root().get_node("Main/UI")
	ui.add_child(transition)
	transition.animation_finished.connect(on_scene_faded_out)


func on_scene_faded_out():
	scene_change.emit(next_scene)

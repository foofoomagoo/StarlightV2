extends Node

signal scene_change(scene: PackedScene)
signal go_to_sleep

@onready var scene_transition = preload("res://scenes/common/scene_transition_ui.tscn")

var current_tilemap: TileMap
var camera_limits
var current_scene
var next_scene: String

#func load_new_scene(scene: PackedScene) -> void:
#	next_scene = scene
#	var transition = scene_transition.instantiate()
#	var ui = get_tree().get_root().get_node("Main/UI")
#	ui.add_child(transition)
#	transition.animation_finished.connect(on_scene_faded_out)

func load_new_scene(scene: String) -> void:
	next_scene = scene
	var transition = scene_transition.instantiate()
	var ui = get_tree().get_root().get_node("Main/UI")
	ui.add_child(transition)
	transition.animation_finished.connect(on_scene_faded_out)


func on_scene_faded_out():
	get_tree().paused = true
	scene_change.emit(next_scene)


func sleep():
	var transition = scene_transition.instantiate()
	var ui = get_tree().get_root().get_node("Main/UI")
	ui.add_child(transition)
	transition.animation_finished.connect(on_sleep)


func on_sleep():
	get_tree().paused = true
	go_to_sleep.emit()

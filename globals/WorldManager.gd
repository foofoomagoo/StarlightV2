extends Node

signal scene_change(scene: PackedScene)
signal go_to_sleep

@onready var scene_transition = preload("res://scenes/common/scene_transition_ui.tscn")

var worlds = [
	{
		"world" : "Ship",
		"init" : true,
		"data" : []
	}, 
	{
		"world" : "Spring",
		"init" : true,
		"data" : [],
		"tiles" : []
	}
	]

var current_tilemap: TileMap
var persist_data: Array
var camera_limits
var current_scene
var next_scene: String


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


func persist_tiles(data):
	worlds[1]["tiles"] = data
	print(worlds[1]["tiles"])

func get_persist_data():
	var save_nodes = get_tree().get_nodes_in_group("Persist")

	persist_data = []
	for node in save_nodes:		
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		
		var node_data = node.call("save")
		persist_data.append(node_data)
		
		for i in worlds:
			if i["world"] == current_scene.scene_name:
				i["data"] = persist_data

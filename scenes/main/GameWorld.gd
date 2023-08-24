extends Node2D

@onready var player = preload("res://entities/player/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	WorldManager.scene_change.connect(on_scene_change)


func remove_scene() -> void:
	for child in get_children():
		remove_child(child)

func on_scene_change(scene: PackedScene):
	remove_scene()
	
	#	Load the next scene
	var new_scene = scene.instantiate()
	add_child(new_scene)
	
	#	Load player
	var player_instance = player.instantiate()
	get_child(0).get_node("YSort").add_child(player_instance)
	
	#	Allow for movement
	Globals.can_move = true

extends Node2D

@onready var player = preload("res://entities/player/player.tscn")
@onready var starting_area = preload("res://scenes/main/levels/starting_area.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	WorldManager.scene_change.connect(on_scene_change)
	WorldManager.go_to_sleep.connect(on_sleep)
	
	var starting_scene = starting_area.instantiate()
	add_child(starting_scene)

func remove_scene() -> void:
	for child in get_children():
		remove_child(child)

func on_scene_change(scene: String):
	WorldManager.get_persist_data()
	remove_scene()
	
	#	Load the next scene
	var new_scene = load(scene)
	var scene_instance = new_scene.instantiate()
	add_child(scene_instance)
	
	#	Load player
	var player_instance = player.instantiate()
	get_child(0).get_node("YSort").add_child(player_instance)
	
	#	Allow for movement
	await get_tree().create_timer(1).timeout
	Globals.toggle_controls()
	get_tree().paused = false
	Globals.can_move = true


func on_sleep() -> void:
	PlayerManager.player.position = Vector2(0, 0)
	PlayerManager.replenish()
	TimeManager.sleep()
	await get_tree().create_timer(1).timeout
	Globals.toggle_controls()
	get_tree().paused = false
	Globals.can_move = true

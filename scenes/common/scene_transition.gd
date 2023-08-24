extends Area2D

@export var scene_to_load: PackedScene


func _on_body_entered(body):
	Globals.can_move = false
	WorldManager.load_new_scene(scene_to_load)
	PlayerManager.player._freeze()

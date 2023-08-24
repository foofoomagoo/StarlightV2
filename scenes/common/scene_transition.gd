extends Area2D

#@export var scene_to_load: PackedScene
@export var scene_to_load: String

func _on_body_entered(body):
	if scene_to_load:
		PlayerManager.player._freeze()
		Globals.can_move = false
		Globals.toggle_controls()
		WorldManager.load_new_scene(scene_to_load)

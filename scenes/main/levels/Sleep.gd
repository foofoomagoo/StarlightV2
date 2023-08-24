extends Area2D

func _on_body_entered(body):
	PlayerManager.player._freeze()
	Globals.can_move = false
	Globals.toggle_controls()
	WorldManager.sleep()

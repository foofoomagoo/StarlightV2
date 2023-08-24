extends Control

signal animation_finished

@onready var animation: AnimationPlayer = $AnimationPlayer


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		animation_finished.emit()
		animation.play("fade_in")

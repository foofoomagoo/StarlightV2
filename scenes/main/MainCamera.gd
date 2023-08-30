extends Camera2D

var target_position = Vector2.ZERO


func _ready():
	make_current()

func _physics_process(delta):
	acquire_target()
	global_position = target_position


func acquire_target():
	var player_node = PlayerManager.player
	target_position = player_node.global_position


func on_limit_update(limits: Array[int]):
	set_limit(SIDE_LEFT, limits[0])
	set_limit(SIDE_TOP, limits[1])
	set_limit(SIDE_RIGHT, limits[2])
	set_limit(SIDE_BOTTOM, limits[3])

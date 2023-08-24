extends Camera2D

var target_position = Vector2.ZERO


func _ready():
	make_current()
#	State.limit_update.connect(on_limit_update)

func _physics_process(delta):
	acquire_target()
#	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 80))
	global_position = target_position


func acquire_target():
	var player_node = PlayerManager.player
	target_position = player_node.global_position
#	var player_nodes = get_tree().get_nodes_in_group("player")
#	if player_nodes.size() > 0:
#		var player = player_nodes[0] as Node2D
#		target_position = player.global_position


func on_limit_update(limits: Array[int]):
	set_limit(SIDE_LEFT, limits[0])
	set_limit(SIDE_TOP, limits[1])
	set_limit(SIDE_RIGHT, limits[2])
	set_limit(SIDE_BOTTOM, limits[3])

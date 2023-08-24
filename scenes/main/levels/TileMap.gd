extends TileMap


func _ready():
	WorldManager.current_tilemap = self


func check_if_farmable(player_position: Vector2) -> bool:
	var map_position = local_to_map(get_local_mouse_position())
	var players_map_position = local_to_map(player_position)

	var distance_from_player_x = abs(players_map_position.x - map_position.x)
	var distance_from_player_y = abs(players_map_position.y - map_position.y)

	var tile_data = get_cell_tile_data(0, map_position)
	
	if tile_data and distance_from_player_x <= 1 and distance_from_player_y <= 1:
		if tile_data.get_custom_data("farmable"):
			return true
		else:
			return false
	else:
		return false


func get_mouse_pos_on_map() -> Vector2:
	var map_position = local_to_map(get_local_mouse_position())
	var local_pos = map_to_local(map_position)
	return local_pos

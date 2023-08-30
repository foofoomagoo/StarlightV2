extends TileMap


func _ready():
	WorldManager.current_tilemap = self


func get_closest_tile(mouse: Vector2, player: Vector2) -> int:
	var tile = get_surrounding_cells(local_to_map(player))
	
	var local_tiles = []
	var close = []

	for i in tile:
		var x = map_to_local(i)
		local_tiles.append(x)

	for i in local_tiles:
		var x = i.distance_to(mouse)
		close.append(x)

	var min = close.min()	
	var find = close.find(min)

	return find

#	match find:
#		0 : print("right")
#		1: print("down")
#		2: print("left")
#		3: print("up")

func check_if_farmable(player_position: Vector2, direction: Vector2) -> bool:
#	var map_position = local_to_map(get_local_mouse_position())
	var players_map_position = local_to_map(player_position) + Vector2i(direction.x, direction.y)

	var tile_data = get_cell_tile_data(0, players_map_position)
	
	if tile_data.get_custom_data(("farmable")):
		return true
	else: 
		return false
#	var distance_from_player_x = abs(players_map_position.x - map_position.x)
#	var distance_from_player_y = abs(players_map_position.y - map_position.y)
#
#	var tile_data = get_cell_tile_data(0, map_position)
#
#	if tile_data and distance_from_player_x <= 1 and distance_from_player_y <= 1:
#		if tile_data.get_custom_data("farmable"):
#			return true
#		else:
#			return false
#	else:
#		return false


func get_mouse_pos_on_map(player: Vector2, direction: Vector2) -> Vector2:
	var players_map_position = local_to_map(player) + Vector2i(direction.x, direction.y)
	var crop_position = map_to_local(players_map_position)
	return crop_position
#	var map_position = local_to_map(get_local_mouse_position())
#	var local_pos = map_to_local(map_position)
#	return local_pos

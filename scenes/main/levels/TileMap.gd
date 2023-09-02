extends TileMap

var highlight: bool
var highlight_cell

func _ready():
	WorldManager.current_tilemap = self


func _process(delta):
	var tool = InventoryManager.selected_hotbar_data.item_data
	if tool is ItemDataTool:
		var player_pos = local_to_map(PlayerManager.player.position)
		var mouse_pos = local_to_map(get_local_mouse_position())
		var tiles = get_surrounding_cells(player_pos)
		
		clear_layer(3)
		for i in tiles:
			if mouse_pos == i:
				set_cell(3, i, 1, Vector2i(0, 0))
			else:
				erase_cell(3, i)
		

func add_watered_tile(crop: Vector2):
	var map_pos = local_to_map(crop)
	var test = get_used_cells(1)
	
	var find = test.find(map_pos)
	
	if find != -1:
		set_cell(2, map_pos, 3, Vector2i(0, 0))
		var terrain = get_used_cells(2)
		set_cells_terrain_connect(2, terrain, 0, 1)
		

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
	

func check_if_farmable(player_position: Vector2, direction: Vector2) -> bool:
	var players_map_position = local_to_map(player_position) + Vector2i(direction.x, direction.y)

	var tile_data = get_cell_tile_data(0, players_map_position)
	
	if tile_data.get_custom_data(("farmable")):
		return true
	else: 
		return false


func get_mouse_pos_on_map(player: Vector2, direction: Vector2) -> Vector2:
	var players_map_position = local_to_map(player) + Vector2i(direction.x, direction.y)
	var crop_position = map_to_local(players_map_position)
	return crop_position


func till(pos: Vector2):
	var map_pos = local_to_map(pos)
	set_cell(1, map_pos, 3, Vector2i(0, 0))
	
	var dirt = get_used_cells(1)
	set_cells_terrain_connect(1, dirt, 0, 1)

	WorldManager.persist_tiles(dirt)

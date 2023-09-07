extends Node2D

@onready var camera_limits: Array[int] = [-2000, -2000, 2000, 2000]
@onready var tilemap = $TileMap
@onready var tree = preload("res://scenes/common/tree.tscn")
@onready var rock = preload("res://scenes/common/rock.tscn")
#@onready var twig = preload("res://scenes/environment/twig.tscn")
@onready var crop_scene = preload("res://scenes/common/crop.tscn")
@onready var ysort = $YSort
@onready var scene_name = "Spring"

var player_position: Vector2i
var noise = FastNoiseLite.new()
var world_data
var tiles
var temperature = {}

var objs = []

func _ready():
	WorldManager.current_scene = self
	
	for i in WorldManager.worlds:
		if i["world"] == scene_name:
			world_data = i["data"]
			if i["init"]:
				objs = [tree, rock]
				tiles = tilemap.get_used_cells_by_id(0, 0, Vector2i(1, 13))
				create_resources()
				i["init"] = false
			else:
				load_resources()
				load_tiles()
	load_crops()


func load_tiles():
	var tiles = WorldManager.worlds[1]["tilled_tiles"]
	
	for i in tiles:
		tilemap.set_cell(1, i, 3, Vector2i(0,0))
	var dirt = tilemap.get_used_cells(1)
	tilemap.set_cells_terrain_connect(1, dirt, 0, 1)
	
	var watered = WorldManager.worlds[1]["watered_tiles"]
	
	for i in watered:
		tilemap.set_cell(2, i, 3, Vector2i(0,0))
	var water = tilemap.get_used_cells(2)
	tilemap.set_cells_terrain_connect(2, water, 0, 1)

func load_crops():
	for i in CropManager.crops:
		var crop = crop_scene.instantiate()
		crop.crop_number = i["crop_number"]
		crop.crop = i["data"].crop
		crop.position = Vector2(i["pos_x"], i["pos_y"])
		crop.grow_state = i["data"].grow_state
		crop.day_planted = i["data"].day_planted
		crop.watered = i["data"].watered
		crop.new = i["data"].new
		get_node("YSort").add_child(crop)


func generate_map(freq, oct):
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_VALUE_CUBIC
	noise.fractal_octaves = oct
	noise.frequency = freq
	var grid_name = {}

	for x in tiles:
		var rand = 2*(abs(noise.get_noise_2d(x.x, x.y)))
		grid_name[Vector2i(x.x, x.y)] = rand

	return grid_name


func create_resources():
	temperature = generate_map(.07, 1)

	for x in tiles:
		var temp = temperature[x]

		if temp < .2:
			create_environment_objects(x, true)
#			tilemap.set_cell(0, Vector2i(x.x, x.y), 0, Vector2i(15, 1))
		else:
#			create_tree(x, 5)
			create_environment_objects(x, false)

func create_environment_objects(pos: Vector2i, forest: bool):
	var rand = randi_range(0, 1)
	var chance = randi_range(0, 100)
	
	if !forest:
		if chance < 5:
			var instance = objs[rand].instantiate()
			instance.position = tilemap.map_to_local(pos)
			ysort.add_child(instance)
	else:
		if chance < 15:
			var instance = objs[0].instantiate()
			instance.position = tilemap.map_to_local(pos)
			ysort.add_child(instance)

func create_tree(pos: Vector2i, odds: int):
	var rand = randi_range(0, 100)
	var test = tilemap.get_cell_atlas_coords(0, pos)
	
	if rand < odds:
		var tree_instance = tree.instantiate()
		tree_instance.position = tilemap.map_to_local(pos)
		ysort.add_child(tree_instance)


func load_resources():
	for node in world_data:
		var new_object = load(node["filename"]).instantiate()
		
		if node["type"] == "Pickup":
			new_object.slot_data = node["data"]
		
		get_node(node["parent"]).add_child(new_object)
		new_object.position = Vector2(node["pos_x"], node["pos_y"])

		for i in node.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node[i])

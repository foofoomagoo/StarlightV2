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
var world_data


func _ready():
	WorldManager.current_scene = self
	load_crops()


func load_crops():
	for i in CropManager.crops:
		var crop = crop_scene.instantiate()
		crop.crop = i["crop"]
		crop.position = Vector2(i["pos_x"], i["pos_y"])
		crop.grow_state = i["grow_state"]
		crop.day_planted = i["day_planted"]
		crop.watered = i["watered"]
		crop.new = i["new"]
		get_node("YSort").add_child(crop)

extends Node

enum tools {AXE, PICKAXE, HOE, WATERINGCAN}
enum environment_type {TREE, ROCK, TWIG}

var new_game: bool

var game_paused: bool
var can_move: bool = true
var disable_controls: bool = false
var store_player



func get_player() -> CharacterBody2D:
	return store_player


func toggle_controls():
	disable_controls = !disable_controls

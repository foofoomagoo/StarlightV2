extends Control

@onready var menu_ui: TextureRect = $MenuUI
@onready var inventory = $Inventory

var menu_region
var buttons

func _ready():
	buttons = $MenuNav.get_children()

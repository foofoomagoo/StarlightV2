extends StaticBody2D

func _ready():
	WorldManager.current_tilemap = null

func _on_interact():
	Globals.computer_open.emit()

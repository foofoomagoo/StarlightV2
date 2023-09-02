extends CanvasLayer

@onready var choice_box = preload("res://ui/consumable_choice_box.tscn")

@onready var inventory_ui: Control = $InGameMenu
@onready var hotbar_ui: Control = $Hotbar
@onready var inventory_data = InventoryManager.inv
@onready var player_stats: Control = $PlayerStats


func _ready():
	PlayerManager.use_consumable.connect(on_eat_consumable)
	InventoryManager.external_inventory_opened.connect(on_external_open)


func on_external_open(data: InventoryData):
	toggle_ui()


func on_eat_consumable(data: ItemDataConsumable):
	var box_instance = choice_box.instantiate()
	box_instance.consumable_data = data
	add_child(box_instance)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and !Globals.disable_controls:
		toggle_ui()


func toggle_ui():
	inventory_ui.visible = !inventory_ui.visible
	hotbar_ui.visible = !hotbar_ui.visible
	player_stats.visible = !player_stats.visible
	
	if !inventory_ui.visible:
		get_tree().paused = false
	else:
		get_tree().paused = true

extends CanvasLayer

@onready var choice_box = preload("res://ui/consumable_choice_box.tscn")

@onready var inventory_ui: Control = $InGameMenu
@onready var hotbar_ui: Control = $Hotbar
@onready var inventory_data = InventoryManager.inv
@onready var player_stats: Control = $PlayerStats
@onready var computer: Control = $Computer


func _ready():
	PlayerManager.use_consumable.connect(on_eat_consumable)
	InventoryManager.external_inventory_opened.connect(on_external_open)
	Globals.computer_open.connect(on_computer_open)
	
func on_computer_open():
	computer.visible = !computer.visible
	toggle()
	get_tree().paused = !get_tree().paused


func toggle():
	hotbar_ui.visible = !hotbar_ui.visible
	player_stats.visible = !player_stats.visible


func on_external_open(data: InventoryData):
	toggle_ui()


func on_eat_consumable(data: ItemDataConsumable):
	var box_instance = choice_box.instantiate()
	box_instance.consumable_data = data
	add_child(box_instance)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and !Globals.disable_controls:
		if computer.visible:
			computer.visible = false
			get_tree().paused = false
		else:
			toggle_ui()


func toggle_ui():
	inventory_ui.visible = !inventory_ui.visible
	hotbar_ui.visible = !hotbar_ui.visible
	player_stats.visible = !player_stats.visible
	
	if !inventory_ui.visible:
		get_tree().paused = false
	else:
		get_tree().paused = true


func _on_button_pressed():
	# Print crops
	print(CropManager.crops)

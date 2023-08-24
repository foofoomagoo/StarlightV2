extends Control

@onready var inventory = InventoryManager.inv
@onready var Slot = preload("res://ui/inventory/slot.tscn")
@onready var item_grid: HBoxContainer = $MarginContainer/HBoxContainer
@onready var highlights: HBoxContainer = $HighlighContainer

var selected_index: int
var previous_index: int
var selected_hotbar_data
var children

func _ready():
	set_inventory_data(InventoryManager.inv)
	InventoryManager.item_picked_up.connect(on_pickup)
	children = highlights.get_children()
	_highlight(0)

func _highlight(index: int) -> void:
	InventoryManager.selected_hotbar_data = inventory.slot_datas[index]
#	selected_hotbar_data = inventory.slot_datas[index]
	selected_index = index
	for i in children:
		i.color = Color("#8c714d00")
	
	children[index].color = Color("#8c714d")

func _process(delta):
	if Input.is_action_pressed("use_item"):
		var slot_data = inventory.slot_datas[selected_index]
		if slot_data:
			slot_data.item_data.use(selected_index)

func on_slot_clicked(index: int, button: int):
	_highlight(index)


func _unhandled_key_input(event):
	if not visible or not event.is_pressed():
		return
	
	if range(KEY_1, KEY_9).has(event.keycode) and !Globals.disable_controls:
		_highlight(event.keycode - KEY_1)
	elif event.keycode == 57:
		_highlight(8)
#		hot_bar_use.emit(8)
	elif event.keycode == 48:
		_highlight(9)
#		hot_bar_use.emit(9)


func on_pickup(index: int) -> void:
	var child = item_grid.get_children()
	
	child[index].set_slot_data(InventoryManager.inv.slot_datas[index])

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_hotbar)
	populate_hotbar(inventory_data)


func populate_hotbar(inventory_data: InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()

	for slot_data in inventory_data.slot_datas.slice(0, 10):
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		slot.slot_clicked.connect(on_slot_clicked)
		

		if slot_data:
			slot.set_slot_data(slot_data)

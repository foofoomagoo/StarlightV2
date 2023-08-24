extends Control

signal drop_slot_data(slot_data: SlotData)

@onready var item_grid : GridContainer = $MarginContainer/InventoryBG/GridContainer
@onready var grabbed_slot: Panel = $GrabbedSlot
@onready var equip_slots: GridContainer = $EquipSlots
@onready var Slot = preload("res://ui/inventory/slot.tscn")

var grabbed_slot_data: SlotData 

func _ready():
	set_inventory_data(InventoryManager.inv, InventoryManager.equip_inv)


func _physics_process(delta) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5, 5)


func set_inventory_data(inventory_data: InventoryData, equip_data: InventoryData):
	inventory_data.inventory_updated.connect(populate_item_grid)
	inventory_data.inventory_interact.connect(on_inventory_interact)
	InventoryManager.item_picked_up.connect(on_pickup)
	populate_item_grid(inventory_data)
	populate_equip(equip_data)


func on_pickup(index: int) -> void:
	var child = item_grid.get_children()
	
	child[index].set_slot_data(InventoryManager.inv.slot_datas[index])


func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
		
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
	
		if slot_data:
			slot.set_slot_data(slot_data)


func populate_equip(inventory_data: InventoryData) -> void:
	for child in equip_slots.get_children():
		child.queue_free()
		
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		equip_slots.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
	
		if slot_data:
			slot.set_slot_data(slot_data)


func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
#		[null, MOUSE_BUTTON_RIGHT]:
#			inventory_data.use_slot_data(index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
			
	updated_grabbed_slot()


func updated_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()


func _on_trash_gui_input(event):
		if event is InputEventMouseButton and event.is_pressed() and visible != false and grabbed_slot_data != null:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					drop_slot_data.emit(grabbed_slot_data)
					# Add this in once you've got your tool code
#					if not grabbed_slot_data.item_data is ItemDataTool:
#						grabbed_slot_data = null
					grabbed_slot_data = null
				MOUSE_BUTTON_RIGHT:
					drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
					if grabbed_slot_data.quantity < 1:
						grabbed_slot_data = null
			
			updated_grabbed_slot()

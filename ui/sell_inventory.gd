extends GridContainer

@onready var Slot = preload("res://ui/inventory/slot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_inventory_data(InventoryManager.inv)


func set_inventory_data(inventory_data: InventoryData):
	inventory_data.inventory_updated.connect(populate_item_grid)
#	inventory_data.inventory_interact.connect(on_inventory_interact)
	populate_item_grid(inventory_data)


func populate_item_grid(data: InventoryData):
	for child in get_children():
		child.queue_free()
		
	for slot_data in data.slot_datas:
		var slot = Slot.instantiate()
		add_child(slot)
		
		slot.slot_clicked.connect(data.on_slot_sell)
	
		if slot_data:
			slot.set_slot_data(slot_data)


func _on_store_container_visibility_changed():
	populate_item_grid(InventoryManager.inv)

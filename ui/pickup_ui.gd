extends Control

@onready var vbox: VBoxContainer = $VBoxContainer
@onready var pickup_container = load("res://scenes/common/pickup_container.tscn")


func _ready():
	InventoryManager.item_picked_up.connect(on_pickup)
	

func on_pickup(index: int, data: SlotData):
	var count = vbox.get_children()
	if !check_if_exists(data.item_data.ITEM_NAME):
		if count.size() >= 3:
			count[0].queue_free()
			
		var item = pickup_container.instantiate()
		item.data = data.item_data
		item.pickup_quantity = 1
		vbox.add_child(item)


func check_if_exists(name: String) -> bool:
	var items = vbox.get_children()
	for i in items:
		if i.data.ITEM_NAME == name:
			i.pickup_quantity += 1
			i.update_label()
			return true
	return false

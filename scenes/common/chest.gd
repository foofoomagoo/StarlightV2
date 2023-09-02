extends StaticBody2D

@export var inventory: InventoryData


func _on_interact():
	InventoryManager.external_inventory_opened.emit(inventory)

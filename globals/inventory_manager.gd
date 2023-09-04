extends Node

signal item_picked_up(index: int)
signal external_inventory_opened(inventory_data: InventoryData)

@onready var inventory_interface = preload("res://ui/inventory/inventory.tscn")
#@onready var hotbar_interface = preload("res://scenes/inventory/hotbar.tscn")
@onready var inv = preload("res://repo/player_inventory.tres")
@onready var equip_inv = preload("res://repo/equip_inventory.tres")

var selected_hotbar_data: SlotData

# Emits data of item that was just picked up
func picked_up(index: int, data: SlotData):
	item_picked_up.emit(index, data)


func subtract_quantity():
	var index = inv.slot_datas.find(selected_hotbar_data)
	inv.use(index)

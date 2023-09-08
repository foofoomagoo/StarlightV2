extends Control

@export var store: Store

@onready var player_inventory = InventoryManager.inv
@onready var inventory: GridContainer = $SellInventory
@onready var buy_inventory: VBoxContainer = $ScrollContainer/BuyList
@onready var buy_item = preload("res://scenes/common/buy_item.tscn")

var store_inventory: Array[SlotData]

func _ready():
	store_inventory = store.INVENTORY.slot_datas
	populate_store(store_inventory)
	

## Populates the scroll container with items to buy
func populate_store(data):
	for i in buy_inventory.get_children():
		i.queue_free()
	
	if store_inventory:
		for item in store_inventory:
			var item_instance = buy_item.instantiate()
			
			if item:
				item_instance.store_item = item.item_data
				item_instance.quantity = item.quantity
				buy_inventory.add_child(item_instance)

				item_instance.item_bought.connect(on_buy)


## Called when an item is clicked on in the store
## Checks to see if it's possible to buy, if it is then call On Buy Success function
func on_buy(data: ItemData, index: int):
	if player_inventory.on_slot_buy(data):
		on_buy_success(data, index)


## Called when item is successfully purchased
## Then repopulates store listing
func on_buy_success(data: ItemData, index: int):
	for i in buy_inventory.get_children():
		i.queue_free()
	
	store_inventory[index].quantity -= 1
	
	if store_inventory[index].quantity <= 0:
		store_inventory.remove_at(index)
		
	populate_store(store_inventory)

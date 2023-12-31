extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

@export var slot_datas: Array[SlotData]

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)


func on_slot_buy(data: ItemData) -> bool:
	if PlayerManager.player_currency >= data.BUY_VALUE:
		var slot = SlotData.new()
		slot.item_data = data
		
		if add_pickup(slot):
			PlayerManager.add_money(-data.BUY_VALUE)
			inventory_updated.emit(self)
			return true
		print("Not enough room.")
		return false
	print("You don't have enough.")
	return false
	
func on_slot_sell(index: int, button: int):
	var slot_data = slot_datas[index]
	
	if slot_data and slot_data.item_data.SELL_VALUE != 0:
		match button:
			1: 
				PlayerManager.add_money(slot_data.item_data.SELL_VALUE * slot_data.quantity)
				slot_datas[index] = null
			2: 
				PlayerManager.add_money(slot_data.item_data.SELL_VALUE)
				slot_data.quantity -= 1
				if slot_data.quantity < 1:
					slot_datas[index] = null
			_:
				print("Not a useful button.")
	inventory_updated.emit(self)

func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null


func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	var return_slot_data: SlotData
	
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
	
	inventory_updated.emit(self)
	return return_slot_data


func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
		
	inventory_updated.emit(self)
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null


func add_pickup(added_slot_data: SlotData) -> bool:
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(added_slot_data):
			slot_datas[index].fully_merge_with(added_slot_data)
			InventoryManager.picked_up(index, added_slot_data)
			return true
			
		if not slot_datas[index]:
			slot_datas[index] = added_slot_data
			InventoryManager.picked_up(index, added_slot_data)
			return true
	return false


func use(index: int):
	slot_datas[index].quantity -= 1
	if slot_datas[index].quantity < 1:
		slot_datas[index] = null
	inventory_updated.emit(self)

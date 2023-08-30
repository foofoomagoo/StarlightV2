extends Node2D

@onready var sprite = $CropSprite
#@onready var interact_area = $Interactable
@onready var pickup = preload("res://scenes/common/pickup.tscn")
@onready var ground = $Ground

var crop: DataCrop
var new: bool = true
var harvested: bool = false
var watered: bool = false
var day_planted = null
var days_to_grow
var grow_state = 0
var crop_selected: bool


func _ready():
	if new:
		new = false
		set_empty_crop()
	elif crop == null:
		load_empty_crop()
	elif crop != null:
		load_crop_info()


func set_empty_crop():
	var crop_info: Dictionary = {
		"pos_x" : position.x,
		"pos_y" : position.y,
		"crop" : null,
		"grow_state" : null,
		"day_planted" : null,
		"watered" : watered,
		"new" : new
	}
	
	CropManager.add_empty_crop(crop_info)

func load_empty_crop():
	if watered:
		ground.modulate = Color(0.647059, 0.164706, 0.164706, 1)


func load_crop_info():
	days_to_grow = crop.time_to_grow
	sprite.texture  = crop.crop_texture
	sprite.hframes = crop.phases
	sprite.set_frame(grow_state)
	if watered:
		ground.modulate = Color(0.647059, 0.164706, 0.164706, 1)


func set_crop(data: DataCrop):
	if crop_selected and crop == null:
		crop = data
		days_to_grow = crop.time_to_grow
		sprite.texture  = crop.crop_texture
		plant_crop()


func plant_crop():
	day_planted = TimeManager.day
	sprite.set_frame(grow_state)
	grow_state = 0
	sprite.hframes = crop.phases
	
	var crop_info: Dictionary = {
		"pos_x" : position.x,
		"pos_y" : position.y,
		"grow_state" : grow_state,
		"day_planted" : day_planted,
		"crop" : crop,
		"harvested" : harvested,
		"days_to_grow" : days_to_grow,
		"watered" : watered,
		"new" : new
	}
	
	CropManager.add_crop(crop_info)


func tool_interact(tool: int):
	match tool:
		0 : _destroy()
		1 : _destroy()
		2 : pass
		3: get_watered()


func get_watered():
#	if InventoryManager.selected_hotbar_data.item_data.tool == 3:
	ground.modulate = Color(0.647059, 0.164706, 0.164706, 1)
	watered == true
	CropManager.water_crop(crop)


func _destroy():
	if crop != null:
		crop = null
		sprite.texture = null
		grow_state = 0
		sprite.set_frame(0)
	
		CropManager.clear_crop(crop, watered)
	else:
		CropManager.remove_crop(crop)
		queue_free()


func _on_interact_area_mouse_entered():
	crop_selected = true


func _on_interact_area_mouse_exited():
	crop_selected = false


func _on_interact():
	if grow_state == (crop.phases - 1) and !harvested:
		var slot_data = SlotData.new()
		slot_data.item_data = crop.harvest
		slot_data.quantity = crop.harvest_quantity
		InventoryManager.inv.add_pickup(slot_data)
		if !crop.regrowable:
			_destroy()
			harvested = true
		else:
			harvested = false
			sprite.set_frame(0)
		print("You havest some " + crop.harvest.ITEM_NAME)
	else:
		print("You can't harvest it yet.")

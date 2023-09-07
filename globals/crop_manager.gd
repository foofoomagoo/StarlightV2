extends Node

@onready var crops = []

var can_show_seed_grid: bool = false
var counter: int = 0


func on_day_tick():
	var current_day = TimeManager.day
#	var non_empty = crops.filter(empty_crops)

	for i in crops:
		if (current_day - i["data"].day_planted == i["data"].days_to_grow) and i["data"].watered:
			print("Crop number " + str(i["crop_number"]) + " grew!")
			i["data"].grow_state += 1
			i["data"].day_planted = current_day
#

	for i in crops:
		i["data"].watered = false
		
	WorldManager.worlds[1]["watered_tiles"] = []


func add_new_crop(data: Dictionary):
	data["crop_number"] = counter
	counter += 1
	crops.append(data)

#func empty_crops(data):
#	return data["data"].crop != null
#
#
#func add_empty_crop(data):
#	data["crop_number"] = counter
#	counter += 1
#	crops.append(data)
#
#
#func add_crop(data):
#	for i in crops:
#		if i["crop_number"] == data.crop_number:
#			i["data"] == data
#	var crop_index = crops.find(data["data"])
#	crops[crop_index] = data
#	print(crops[crop_index])
#	print(crop_index)


func water_crop(data):
	for i in crops:
		if i["crop_number"] == data.crop_number:
			i["data"].watered = true
#	crops[crop_index]["data"]["watered"] = true


#func remove_crop(data):
#	crops.erase(data)

func remove_crop(data: int):
	for i in crops:
		if i["crop_number"] == data:
			crops.erase(i)
			print("Crop erased.")


func clear_crop(data, watered: bool):
	var crop_index = crops.find(data)
	crops[crop_index]["grow_state"] = 0
	crops[crop_index]["day_planted"] = null
	crops[crop_index]["watered"] = watered
	crops[crop_index]["crop"] = null

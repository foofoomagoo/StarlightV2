extends Node

@onready var crops = []

var can_show_seed_grid: bool = false


func on_day_tick():
	print("Day tick")
	var current_day = TimeManager.day
	var non_empty = crops.filter(empty_crops)
	
	for i in non_empty:
		if (current_day - i["day_planted"] == i["days_to_grow"]) and i["watered"] and i["crop"] != null:
			i["grow_state"] += 1
			i["day_planted"] = current_day
			i["watered"] = false


func empty_crops(data):
	return data["crop"] != null


func add_empty_crop(data) -> void:
	crops.append(data)


func add_crop(data: Dictionary):
	var crop_index = crops.find(data)
	crops[crop_index] = data


func water_crop(data):
	var crop_index = crops.find(data)
	crops[crop_index]["watered"] = true

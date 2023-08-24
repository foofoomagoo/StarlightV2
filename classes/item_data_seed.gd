extends ItemData
class_name ItemDataSeed

@export var crop_data: DataCrop

func use(index: int) -> void:
	PlayerManager.place_seed(crop_data, index)

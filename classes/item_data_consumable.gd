extends ItemData
class_name ItemDataConsumable

@export var heal_value: int
@export var energy_value: int

func use(index: int) -> void:
	if heal_value != 0:
		PlayerManager.eat_consumable(self)

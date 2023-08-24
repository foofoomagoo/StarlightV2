extends Node

signal energy_tick(amount: int)
signal health_tick(amount: int)
signal use_consumable(item_data: ItemDataConsumable)

var player
var player_health: int = 5
var player_energy: int = 100
var consuming: bool = false
var timer

func _ready():
	#	Timer is used to control the timing of tool use
	timer = Timer.new()
	timer.wait_time = 1
	timer.one_shot = true
	add_child(timer)

#	Called when a consumable item from hotbar is used.
#	Emits a signal, which is picked up by UI
func eat_consumable(data: ItemDataConsumable) -> void:
	if !consuming:
		consuming = true
		use_consumable.emit(data)

#	Called when the player chooses 'yes' from UI
func heal(data: ItemDataConsumable) -> void:
	consuming = false
	InventoryManager.subtract_quantity()
	player_health = clamp(player_health + data.heal_value, 0, 8)
	health_tick.emit(player_health)

#	Called when a tool is used from hotbar
func use_tool(data) -> void:
	if timer.is_stopped():
		timer.start()
		player.swing_tool(data)
	else:
		player.stop_tool(data)


# Called when an action uses energy
func use_energy(amount: int):
	player_energy -= amount
	energy_tick.emit(amount)
	if player_energy <= 0:
		#	Insert sleep logic here
		print("You pass out.")


func place_seed(data: DataCrop, index: int):
	if timer.is_stopped():
		timer.start()
		player._seed(data)


func replenish():
	player_energy = 100
	player_health = 8
	
	health_tick.emit(8)
	energy_tick.emit(-100)

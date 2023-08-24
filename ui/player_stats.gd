extends Control

@onready var energy: ProgressBar = $ProgressBar
@onready var health: TextureProgressBar = $HealthContainer/TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.energy_tick.connect(on_energy_tick)
	PlayerManager.health_tick.connect(on_health_tick)
	health.value = PlayerManager.player_health

func on_energy_tick(amount: int):
	energy.value -= amount


func on_health_tick(amount: int):
	health.value = PlayerManager.player_health

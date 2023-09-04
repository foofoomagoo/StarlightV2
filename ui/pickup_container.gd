extends NinePatchRect

@onready var image: TextureRect = $Image/TextureRect
@onready var name_label: Label = $name
@onready var quantity_label: Label = $quantity
@onready var timer: Timer = $Timer

@export var data: ItemData
@export var pickup_quantity: int


func _ready():
	timer.start()
	
	
	image.texture = data.ITEM_TEXTURE
	name_label.text = data.ITEM_NAME
	quantity_label.text = str(pickup_quantity)


func _process(delta):
	if timer.time_left <= 3:
		modulate.a -= .005


func update_label():
	modulate.a = 1.0
	timer.start()
	quantity_label.text = str(pickup_quantity)


func _on_timer_timeout():
	queue_free()

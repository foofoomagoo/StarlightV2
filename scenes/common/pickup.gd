extends Node2D

@export var slot_data: SlotData

@onready var sprite_2d: Sprite2D = $Path2D/PathFollow2D/Sprite2D
@onready var path = $Path2D/PathFollow2D
@onready var animation = $AnimationPlayer

var travel: bool

func _ready():
	print(position)
	animation.play("drop")
	if slot_data:
		sprite_2d.texture = slot_data.item_data.ITEM_TEXTURE
#	if slot_data.item_data.STATIC:
#		set_collision_layer(16)
#		set_collision_mask(4)

func _process(delta):
	pass
#	if position.distance_to(PlayerManager.player.position) <= 5:
#		queue_free()
#	if travel:
#		global_position = global_position.move_toward(PlayerManager.player.global_position, delta * 100)

func _on_area_2d_body_entered(body):
		if !slot_data.item_data.STATIC and path.progress_ratio == 1:
			if InventoryManager.inv.add_pickup(slot_data):
				queue_free()

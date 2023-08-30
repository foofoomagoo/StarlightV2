extends StaticBody2D

@export var environment_data: EnvironmentData

@onready var loot_container = preload("res://scenes/common/pickup.tscn")
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

var health: int
var loot: ItemData
var loot_quantity: int
var shake_loot_data
var interacted_with: bool = false
var shake_anim_finished: bool = true
var mouse_in: bool = false
var required_tool_type

func _ready():
	health = environment_data.HEALTH
	loot = environment_data.LOOT
	loot_quantity = environment_data.LOOT_QUANTITY
	required_tool_type = environment_data.TOOL_TYPE
	shake_loot_data = environment_data.INTERACT_LOOT

func _on_interact():
	if !interacted_with and shake_loot_data != null:
		interacted_with = true
		
		var rand = randi_range(0, 10)
		
		if rand <= 5:
			for i in environment_data.INTERACT_LOOT_QUANTITY:
				var new_slot = SlotData.new()
				new_slot.item_data = shake_loot_data
				var loot_instance = loot_container.instantiate()
				loot_instance.slot_data = new_slot
				get_parent().call_deferred("add_child", loot_instance)
				var rand_dir_y = randi_range(10, 25)
				loot_instance.position = Vector2(position.x, position.y + rand_dir_y)
				print("You shake the thing and a bunch of stuff falls out")
				await get_tree().create_timer(.05).timeout
		else:
			print("Not blueberries here.")


func take_damage(damage: int, type: int) -> void:
	if shake_anim_finished and type == environment_data.TOOL_TYPE:
		health -= damage
		animation.play("shake")
		shake_anim_finished = false
		if health <= 0:
			destroy_object()


func drop_loot():
	for i in loot_quantity:
		var new_slot = SlotData.new()
		new_slot.item_data = loot
		var loot_instance = loot_container.instantiate()
		loot_instance.slot_data = new_slot
		var rand_dir_x = randi_range(-10, 10)
		var rand_dir_y = randi_range(-10, 10)

		var loot_pos = Vector2(position.x + rand_dir_x, position.y + rand_dir_y)
		loot_instance.position = loot_pos
#		get_tree().get_root().call_deferred("add_child", loot_instance)
		get_parent().call_deferred("add_child", loot_instance)
	print("Object dropped " + str(loot_quantity) + " pieces of " + loot.ITEM_NAME)
#
	call_deferred("queue_free")


func destroy_object() -> void:
	animation.play("destroyed")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "destroyed":
		drop_loot()
		return
	shake_anim_finished = true


func _on_interact_area_mouse_entered():
	mouse_in = true


func _on_interact_area_mouse_exited():
	mouse_in = false


func save():
	var save_dictionary: Dictionary = {
		"type" : "Environment Object",
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"health" : health,
		"interacted_with" : interacted_with
	}
	return save_dictionary

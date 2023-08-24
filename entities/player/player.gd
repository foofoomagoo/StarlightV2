extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var animation = $AnimationTree
@onready var all_interactions = []
@onready var crop: PackedScene = preload("res://scenes/common/crop.tscn")

var speed: int = 50
var current_tool: int

func _ready():
	PlayerManager.player = self
	animation.active = true


func _physics_process(delta):
	if Globals.can_move:
		move()
	
	
#MOVEMENT CODE
func move():
	var input_vector = get_movement_vector()
	var move_direction = input_vector.normalized()
	velocity = move_direction * speed
	
	if velocity == Vector2.ZERO:
		animation.get("parameters/playback").travel("Idle")
		animation["parameters/conditions/idle"] = true
		animation["parameters/conditions/is_moving"] = false
	else:
		animation["parameters/conditions/idle"] = false
		animation["parameters/conditions/is_moving"] = true
		animation.get("parameters/playback").travel("Run")
		animation.set("parameters/Idle/blend_position", move_direction)
		animation.set("parameters/Run/blend_position", move_direction)
		animation.set("parameters/SwingTool/Axe/blend_position", move_direction)
		animation.set("parameters/SwingTool/Pickaxe/blend_position", move_direction)
		animation.set("parameters/SwingTool/Hoe/blend_position", move_direction)
		animation.set("parameters/SwingTool/Water/blend_position", move_direction)
	
	move_and_slide()


func _unhandled_input(event):
	if event is InputEvent:
		if event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
			execute_interaction()



func swing_tool(tool: int):
	Globals.can_move = false
	animation["parameters/conditions/swing"] = true
	current_tool = tool
	match tool:
		0: 
			animation["parameters/SwingTool/conditions/axe"] = true
			animation["parameters/SwingTool/conditions/pickaxe"] = false
			animation["parameters/SwingTool/conditions/hoe"] = false
			animation["parameters/SwingTool/conditions/water"] = false
		1:
			animation["parameters/SwingTool/conditions/pickaxe"] = true
			animation["parameters/SwingTool/conditions/axe"] = false
			animation["parameters/SwingTool/conditions/hoe"] = false
			animation["parameters/SwingTool/conditions/water"] = false
		2:
			animation["parameters/SwingTool/conditions/hoe"] = true
			animation["parameters/SwingTool/conditions/pickaxe"] = false
			animation["parameters/SwingTool/conditions/axe"] = false
			animation["parameters/SwingTool/conditions/water"] = false
			use_hoe()
		3:	
			animation["parameters/SwingTool/conditions/water"] = true
			animation["parameters/SwingTool/conditions/hoe"] = false
			animation["parameters/SwingTool/conditions/pickaxe"] = false
			animation["parameters/SwingTool/conditions/axe"] = false
			

func stop_tool(tool: int):
	animation["parameters/conditions/swing"] = false


func use_hoe():
	if WorldManager.current_tilemap and WorldManager.current_tilemap.check_if_farmable(position):
		var mouse_pos = WorldManager.current_tilemap.get_mouse_pos_on_map()
		var item_instance = crop.instantiate()
		item_instance.position = mouse_pos
		get_parent().add_child(item_instance)


func _seed(data: DataCrop):
	if all_interactions:
		var distances = []
		for i in all_interactions:
			distances.append(position.distance_to(i.position))
		var min = distances.min()
		var current_interaction = all_interactions[distances.find(min)]
		match current_interaction.interact_type:
			"crop" : 
				current_interaction.get_parent().set_crop(data)
				InventoryManager.subtract_quantity()

func get_tile_position(position: Vector2) -> Vector2:
	var x = int(position.x / 16) * 16
	var y = int(position.y / 16) * 16
	return Vector2(x, y)


func _on_animation_tree_animation_finished(anim_name):
	use_tool(current_tool)
	Globals.can_move = true


func get_movement_vector():
	var x_movement = Input.get_action_raw_strength("ui_right") - Input.get_action_raw_strength("ui_left")
	var y_movement = Input.get_action_raw_strength("ui_down") - Input.get_action_strength("ui_up")
	
	return Vector2(x_movement, y_movement)


func use_tool(tool: int):
	if all_interactions:
		var distances = []
		for i in all_interactions:
			distances.append(position.distance_to(i.position))
		var min = distances.min()
		var current_interaction = all_interactions[distances.find(min)]
		
		match current_interaction.interact_type:
			"environment" : 
				current_interaction.get_parent().take_damage(10, tool)
				PlayerManager.use_energy(2)
			"crop":
				current_interaction.get_parent().get_watered()


func execute_interaction():
	if all_interactions:
		var distances = []
		for i in all_interactions:
			distances.append(position.distance_to(i.position))
		var min = distances.min()
		var current_interaction = all_interactions[distances.find(min)]
		match current_interaction.interact_type:
			"environment" : current_interaction.get_parent()._on_interact()
			"structure" : current_interaction.get_parent()._on_interact()
#			"chest" : current_interaction.get_parent()._on_interact()
#			"npc" : start_dialogue.emit(current_interaction.get_parent().get_dialogue_data())
#			"seed" : current_interaction.use()



func _on_interact_area_area_entered(area):
	all_interactions.insert(0, area)

func _on_interact_area_area_exited(area):
	all_interactions.erase(area)


func _freeze():
	animation.get("parameters/playback").travel("Idle")

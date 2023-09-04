extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var animation = $AnimationTree
@onready var all_interactions = []
@onready var crop: PackedScene = preload("res://scenes/common/crop.tscn")
@onready var raycast = $RayCast2D

var speed: int = 50
var current_tool: int
var tool_array = ["axe", "pickaxe", "hoe", "water"]
var previous_dir
var tilemap: TileMap

func _ready():
	print(position)
	PlayerManager.player = self
	tilemap = WorldManager.current_tilemap
	animation.active = true
	animation.get("parameters/playback").travel("Idle")
	animation["parameters/conditions/idle"] = true

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
		raycast.target_position = (animation.get("parameters/Idle/blend_position") * 20)
	else:
		previous_dir = move_direction
		animation["parameters/conditions/idle"] = false
		animation["parameters/conditions/is_moving"] = true
		animation.get("parameters/playback").travel("Run")
		animation.set("parameters/Idle/blend_position", move_direction)
		animation.set("parameters/Run/blend_position", move_direction)
		animation.set("parameters/SwingTool/Axe/blend_position", move_direction)
		animation.set("parameters/SwingTool/Pickaxe/blend_position", move_direction)
		animation.set("parameters/SwingTool/Hoe/blend_position", move_direction)
		animation.set("parameters/SwingTool/Water/blend_position", move_direction)
		raycast.target_position = (animation.get("parameters/Run/blend_position") * 20)
	move_and_slide()


func _unhandled_input(event):
	if event is InputEvent:
		if event.is_action_pressed("interact"):
			execute_interaction()
			get_viewport().set_input_as_handled()

func get_direction(tool: String, mouse: Vector2):
	if tilemap:
		var closest_tile = tilemap.get_closest_tile(mouse, position)
	
		match closest_tile:
			0 : 
				animation.set("parameters/SwingTool/" + tool + "/blend_position", Vector2.RIGHT)
				animation.set("parameters/Idle/blend_position", Vector2.RIGHT)
				raycast.target_position = Vector2(16, 0)
			1 : 
				animation.set("parameters/SwingTool/" + tool + "/blend_position", Vector2.DOWN)
				animation.set("parameters/Idle/blend_position", Vector2.DOWN)
				raycast.target_position = Vector2(0, 16)
			2 : 
				animation.set("parameters/SwingTool/" + tool + "/blend_position", Vector2.LEFT)
				animation.set("parameters/Idle/blend_position", Vector2.LEFT)
				raycast.target_position = Vector2(-16, 0)
			3 : 
				animation.set("parameters/SwingTool/" + tool + "/blend_position", Vector2.UP)
				animation.set("parameters/Idle/blend_position", Vector2.UP)
				raycast.target_position = Vector2(0, -16)

func swing_tool(tool: int):
	var mouse_pos = get_global_mouse_position()
	
	Globals.can_move = false
	animation["parameters/conditions/swing"] = true
	current_tool = tool
	match tool:
		0: 
			get_direction("Axe", mouse_pos)
			loop_tools("axe")
		1:
			get_direction("Pickaxe", mouse_pos)
			loop_tools("pickaxe")
		2:
			get_direction("Hoe", mouse_pos)
			loop_tools("hoe")
		3:	
			get_direction("Water", mouse_pos)
			loop_tools("water")
			

func loop_tools(tool: String):
	for i in tool_array:
		if i == tool:
			animation["parameters/SwingTool/conditions/" + tool] = true
		else:
			animation["parameters/SwingTool/conditions/" + i] = false


func stop_tool(tool: int):
	animation["parameters/conditions/swing"] = false


func use_hoe():
	WorldManager.current_tilemap.highlight = true
	var tile = animation.get("parameters/Idle/blend_position")
	if WorldManager.current_tilemap and WorldManager.current_tilemap.check_if_farmable(position, tile):
		if !raycast.is_colliding():
			var crop_pos = WorldManager.current_tilemap.get_mouse_pos_on_map(position, tile)
			var item_instance = crop.instantiate()
			item_instance.position = crop_pos
			get_parent().add_child(item_instance)
			WorldManager.current_tilemap.till(crop_pos)

func _seed(data: DataCrop):
	if raycast.is_colliding():
		var target = raycast.get_collider()
		
		if target.interact_type == "crop" and target.get_parent().crop == null:
			target.get_parent().set_crop(data)
			InventoryManager.subtract_quantity()

func get_tile_position(position: Vector2) -> Vector2:
	var x = int(position.x / 16) * 16
	var y = int(position.y / 16) * 16
	return Vector2(x, y)


func _on_animation_tree_animation_finished(anim_name):
	match current_tool:
		0 : use_tool(current_tool)
		1 : use_tool(current_tool)
		2 : use_hoe()
		3 : use_watering_can()
			#use_tool(current_tool)
	Globals.can_move = true


func use_watering_can():
	var tile = animation.get("parameters/Idle/blend_position")
	if tilemap.check_if_farmable(position, tile):
		var crop_pos = WorldManager.current_tilemap.get_mouse_pos_on_map(position, tile)
		tilemap.add_watered_tile(crop_pos)


func get_movement_vector():
	var x_movement = Input.get_action_raw_strength("ui_right") - Input.get_action_raw_strength("ui_left")
	var y_movement = Input.get_action_raw_strength("ui_down") - Input.get_action_strength("ui_up")
	
	return Vector2(x_movement, y_movement)


func use_tool(tool: int):
	if raycast.is_colliding():
		var target = raycast.get_collider()
		match target.interact_type:
			"environment" : 
				target.get_parent().take_damage(10, tool)
				PlayerManager.use_energy(2)
			"crop":
				target.get_parent().tool_interact(tool)


func execute_interaction():
	if raycast.is_colliding():
		var target = raycast.get_collider()
		target.get_parent()._on_interact()
#	if all_interactions:
#		var distances = []
#		for i in all_interactions:
#			distances.append(position.distance_to(i.position))
#		var min = distances.min()
#		var current_interaction = all_interactions[distances.find(min)]
#		match current_interaction.interact_type:
#			"environment" : current_interaction.get_parent()._on_interact()
#			"structure" : current_interaction.get_parent()._on_interact()
#			"crop" : current_interaction.get_parent()._on_interact()


func _on_interact_area_area_entered(area):
	area.travel = true
	all_interactions.insert(0, area)

func _on_interact_area_area_exited(area):
	all_interactions.erase(area)


func _freeze():
	animation.get("parameters/playback").travel("Idle")

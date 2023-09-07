extends Control

@onready var label: RichTextLabel = $TextContainer/RichTextLabel
@onready var yes_btn: Button = $TextContainer/VBoxContainer/YesBtn
@onready var no_btn: Button = $TextContainer/VBoxContainer/NoBtn

var consumable_data: ItemDataConsumable


func _ready():
	get_tree().paused = true
	label.text = "Would you  like to eat a " + consumable_data.ITEM_NAME + "?"
	Globals.toggle_controls()


func _on_yes_btn_pressed():
	Globals.toggle_controls()
	get_tree().paused = false
	PlayerManager.heal(consumable_data)
	queue_free()


func _on_no_btn_pressed():
	Globals.toggle_controls()
	get_tree().paused = false
	PlayerManager.consuming = false
	queue_free()

extends Control

signal item_bought(store_item: ItemData)

@onready var texture: TextureRect = $HBoxContainer/ItemImgContainer/TextureRect
@onready var name_label: Label = $HBoxContainer/Name
@onready var cost_label: Label = $HBoxContainer/Cost
@onready var quantity_label: Label = $HBoxContainer/ItemImgContainer/quantity


var store_item: ItemData
var quantity: int

func _ready():
	texture.texture = store_item.ITEM_TEXTURE
	name_label.text = store_item.ITEM_NAME
	cost_label.text = str(store_item.BUY_VALUE)
	quantity_label.text = str(quantity)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		item_bought.emit(store_item, get_index())

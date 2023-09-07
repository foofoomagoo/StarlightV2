extends Control

@onready var pages: Control = $Pages

var pages_list = []

func _ready():
	pages_list = pages.get_children()


func _on_button_pressed():
	Globals.computer_open.emit()


func _open_page(index: int):
	for i in pages_list:
		i.visible = false
	
	pages_list[index].visible = true


func _on_msg_btn_pressed():
	_open_page(0)
	

func _on_store_btn_pressed():
	_open_page(1)
	

func _on_mission_btn_pressed():
	_open_page(2)


func _on_visibility_changed():
	for i in pages_list:
		i.visible = false

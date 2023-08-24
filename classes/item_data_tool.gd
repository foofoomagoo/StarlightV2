extends ItemData
class_name ItemDataTool

@export var delay: float
@export var tool: Globals.tools


func use(index: int) -> void:
	PlayerManager.use_tool(tool)

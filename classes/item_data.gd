extends Resource
class_name ItemData

@export var ITEM_NAME: String
@export var ITEM_TEXTURE: AtlasTexture
@export_enum ("Tool", "Seed", "Resource", "Gem", "Artifact") var ITEM_TYPE: String
@export var STACKABLE: bool
@export_multiline var HOVER_TEXT: String
@export var STATIC: bool
@export var SELL_VALUE: int


func use(index: int) -> void:
	pass


func getTexture() -> Texture:
	return ITEM_TEXTURE

extends Resource

const Character_Class = preload("res://addons/godot-imgui/examples/05_dialogue/src/dialogue_character.gd")

enum Line_Type {
	Normal,
	Choice,
	Action,
}

export var text: String
export var character: Resource
export(Line_Type) var line_type: int
export var options = []





extends Resource

#const Character_Class = preload("res://data/dialogue/dialogue_character.gd")

export var text: String
#export(Character_Class) var character
export var character: Resource

enum Character_Mood {
	NONE,
	HAPPY,
	SAD,
}

export(Character_Mood) var mood



extends Resource

enum Direction {
	North,
	East,
	South,
	West,
}

export var text: String
export var done: bool
export(Direction) var direction := Direction.North


extends KinematicBody

var shouldMove = false
var dir:Vector3 = Vector3.ZERO

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func move(forward:Vector3):
	shouldMove = true
	dir = forward
	

func _physics_process(delta):
	if(shouldMove):
		translate(dir * 0.1)
		shouldMove = false
	
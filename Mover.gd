extends Area

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

class_name Mover
		
func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for i in bodies:
		if i.has_method("move"):
			i.move(global_transform.basis.xform(Vector3.FORWARD))
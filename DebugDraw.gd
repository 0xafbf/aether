extends ImmediateGeometry

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var size = 0.1
func _on_Character_test_hit(location, normal):
	clear()
	begin(Mesh.PRIMITIVE_LINES)
	add_vertex(location+Vector3(-size, 0 ,0))
	add_vertex(location+Vector3( size, 0 ,0))
	add_vertex(location+Vector3(0, -size, 0))
	add_vertex(location+Vector3(0,  size, 0))
	add_vertex(location+Vector3(0, 0, -size))
	add_vertex(location+Vector3(0, 0,  size))
	add_vertex(location)
	add_vertex(location + normal * 2 * size)
	end()

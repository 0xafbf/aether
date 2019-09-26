
extends ImmediateGeometry

export var x_steps = 20
export var y_steps = 20

export var x_size = 4
export var y_size = 4
export var primitive = Mesh.PRIMITIVE_LINES

func _process(delta):
	clear()
	begin(primitive)
	
	for idx in range(x_steps):
		var x = (float(idx) / x_steps - 0.5) * x_size
		for jdx in range(y_steps):
			var y = (float(jdx) / y_steps - 0.5) * y_size
			add_vertex(Vector3(x, 0, y))
			add_vertex(Vector3(x, sin(x) + sin(y), y))
			
	end()

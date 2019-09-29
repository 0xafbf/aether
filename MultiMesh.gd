
extends MultiMeshInstance

export var x_steps = 20
export var y_steps = 20

export var x_size = 4
export var y_size = 4


var accum: float = 0

func _process(delta):
	
	accum += delta
	multimesh.set_instance_count(0)
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	
	var instance_count = x_steps * y_steps
	multimesh.set_instance_count(instance_count)
	
	multimesh.set_visible_instance_count(instance_count)

	
	for idx in range(x_steps):
		var x = (float(idx) / x_steps - 0.5) * x_size
		for jdx in range(y_steps):
			var y = (float(jdx) / y_steps - 0.5) * y_size
			var z = sin(x+accum) + sin(y)
			var t_idx = idx * y_steps + jdx
			if t_idx < multimesh.instance_count:
				var transf = Transform(Basis(), Vector3(x, z, y))
				multimesh.set_instance_transform(t_idx, transf)

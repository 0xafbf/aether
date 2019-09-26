extends Spatial

class_name Brush

enum {BRUSH_OFF, BRUSH_BUILD, BRUSH_DESTROY, BRUSH_EDIT}

var current_mode = BRUSH_OFF

export var build_mat: Material
export var destroy_mat: Material
export var edit_mat: Material

var target: Brick

func set_target(in_target: Brick):
	target = in_target
	if (target):
		extents = target.extents
	else:
		extents = Vector3(1,1,1)
	
	$MeshInstance.scale = extents + Vector3(0.02, 0.02, 0.02)

func _ready():
	set_target(null)

func set_mode(new_mode):
	current_mode = new_mode
	
	var mesh = $MeshInstance
	mesh.visible = (current_mode != BRUSH_OFF)
	if current_mode == BRUSH_BUILD:
		mesh.material_override = build_mat
	elif current_mode == BRUSH_DESTROY:
		mesh.material_override = destroy_mat
	elif current_mode == BRUSH_EDIT:
		mesh.material_override = edit_mat
		

var extents = Vector3(1,1,1)
func snap_to_position_and_direction(in_position: Vector3, in_direction: Vector3):
	var local_direction = transform.basis.xform_inv(in_direction)
	var local_offset = local_direction * extents
	var world_offset = transform.basis.xform(local_offset)
	translation = in_position + world_offset
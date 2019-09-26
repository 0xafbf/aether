extends Spatial

class_name Brick

onready var brick_collision = $BrickCollision


export var margin = 0.2

export var extents: Vector3 setget set_extents

var snap_size = 0.5

tool

func set_extents(in_extents):
	in_extents = in_extents / snap_size
	extents.x = max(int(in_extents.x), 1)
	extents.y = max(int(in_extents.y), 1)
	extents.z = max(int(in_extents.z), 1)
	
	extents = extents * snap_size
	update_collision()
	
	
var shape_owner = -1
func update_collision():
	var shape = BoxShape.new()
	shape.extents = extents
	if $BrickCollision:
		if shape_owner == -1:
			shape_owner = $BrickCollision.create_shape_owner(self)
			
		$BrickCollision.shape_owner_clear_shapes(shape_owner)
		$BrickCollision.shape_owner_add_shape(shape_owner, shape)
		# $BrickCollision/CollisionShape. = shape
		$BrickCollision/MeshInstance.scale = extents

func _ready():
	set_extents(extents)

func get_suggested_build_direction(world_position):
	var local_coordinates = to_local(world_position)
	var abs_local_coordinates = Vector3(abs(local_coordinates.x), abs(local_coordinates.y), abs(local_coordinates.z))
	
	var major_axis = abs_local_coordinates.max_axis()
	var minor_axis = abs_local_coordinates.min_axis()
	var second_axis = 3 - major_axis - minor_axis

	var suggested_direction = Vector3()
	
	var test = abs(local_coordinates[second_axis]) + margin
	if test > extents[second_axis]:
		# near to the edge, build sideways
		suggested_direction[second_axis] = sign(local_coordinates[second_axis])
	else:
		# build in face direction
		suggested_direction[major_axis] = sign(local_coordinates[major_axis])
		
	
	return transform.basis.xform(suggested_direction)

func get_snapping_position(world_position):
	var local_coordinates = to_local(world_position)
	var abs_local_coordinates = Vector3(abs(local_coordinates.x), abs(local_coordinates.y), abs(local_coordinates.z))
	
	var major_axis = abs_local_coordinates.max_axis()
	var minor_axis = abs_local_coordinates.min_axis()
	var second_axis = 3 - major_axis - minor_axis
	
	var pos = Vector3()
	
	var test = abs(local_coordinates[second_axis]) + margin
	if test > extents[second_axis]:
		pos[second_axis] = extents[second_axis] * sign(local_coordinates[second_axis])
	else:
		pos[major_axis] = extents[major_axis] * sign(local_coordinates[major_axis])
	
	return transform.xform(pos)
	
	
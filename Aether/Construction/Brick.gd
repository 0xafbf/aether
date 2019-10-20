extends Spatial

class_name Brick

export var margin = 0.2
export var extents: Vector3 setget set_extents
var snap_size = 0.5

tool

var owned_material_id = -1
onready var owned_material:Material = null
func get_owned_material(desired_id):

	print("getting mat:%s" % desired_id)
	if desired_id == owned_material_id:
		if owned_material:
			return owned_material
	owned_material_id = desired_id

	if owned_material_id < skin_materials.size():
		var new_material = skin_materials[owned_material_id]
		owned_material = new_material.duplicate()
		$BrickCollision/MeshInstance.material_override = owned_material
	else:
		owned_material = null
	print(owned_material)
	return owned_material

func set_extents(in_extents):
	in_extents = in_extents / snap_size
	extents.x = max(int(in_extents.x), 1)
	extents.y = max(int(in_extents.y), 1)
	extents.z = max(int(in_extents.z), 1)

	extents = extents * snap_size
	print(brick_mesh)
	if brick_mesh:
		brick_mesh.scale = extents


	var mat = get_owned_material(skin)
	if mat:
		mat.set_shader_param("box_size", extents)

	update_collision()

var shape_owner = -1

onready var brick_collision: StaticBody = $BrickCollision
onready var brick_mesh = $BrickCollision/MeshInstance

func update_collision():
	var shape = BoxShape.new()
	shape.extents = extents
	if brick_collision:
		if shape_owner == -1:
			shape_owner = brick_collision.create_shape_owner(self)

		brick_collision.shape_owner_clear_shapes(shape_owner)
		brick_collision.shape_owner_add_shape(shape_owner, shape)
		# $BrickCollision/CollisionShape. = shape


func _ready():
	print("calling ready")
	set_extents(extents)

func get_suggested_build_direction(world_position):
	var local_coordinates = to_local(world_position)
	var cube_coordinates = local_coordinates / extents
	var abs_cube_coordinates = Vector3(abs(cube_coordinates.x), abs(cube_coordinates.y), abs(cube_coordinates.z))

	var major_axis = abs_cube_coordinates.max_axis()
	var minor_axis = abs_cube_coordinates.min_axis()
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

	var cube_coordinates = local_coordinates / extents
	var abs_cube_coordinates = Vector3(abs(cube_coordinates.x), abs(cube_coordinates.y), abs(cube_coordinates.z))

	var major_axis = abs_cube_coordinates.max_axis()
	var minor_axis = abs_cube_coordinates.min_axis()
	var second_axis = 3 - major_axis - minor_axis

	var pos = Vector3()

	var test = abs(local_coordinates[second_axis]) + margin
	if test > extents[second_axis]:
		# aiming border: project onto side...
		pos[second_axis] = extents[second_axis] * sign(local_coordinates[second_axis])
	else:
		pos[major_axis] = extents[major_axis] * sign(local_coordinates[major_axis])
		pos[second_axis] = int(local_coordinates[second_axis]/snap_size) * snap_size
		pos[minor_axis] = int(local_coordinates[minor_axis]/snap_size) * snap_size

	return transform.xform(pos)


export var skin = 0 setget set_skin
enum { SKIN_0, SKIN_WOOD, SKIN_METAL }
export(Array, Material) var skin_materials
func set_skin(skin_id):
	skin_id = clamp(skin_id, 0, skin_materials.size()-1)
	if skin_id != skin:
		skin = skin_id
		if skin != -1:
			get_owned_material(skin)
			set_extents(extents)
			#$BrickCollision/MeshInstance.material_override = skin_materials[skin]

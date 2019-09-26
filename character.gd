
extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

export var cam_speed = 0.003
var pitch = 0
var yaw = 0
var rotation_snaps = 48

func _input(event):
	if event.is_action_pressed("jump"):
		jump()
	elif event.is_action_pressed("fire"):
		fire()
	elif event.is_action_pressed("slot_1"):
		set_build_mode(Brush.BRUSH_OFF)
	elif event.is_action_pressed("slot_2"):
		set_build_mode(Brush.BRUSH_BUILD)
	elif event.is_action_pressed("slot_3"):
		set_build_mode(Brush.BRUSH_DESTROY)
	elif event.is_action_pressed("slot_4"):
		set_build_mode(Brush.BRUSH_EDIT)
		
	elif event.is_action_pressed("variant_next"):
		spawn_rotation += (TAU/rotation_snaps)
	elif event.is_action_pressed("variant_previous"):
		spawn_rotation -= (TAU/rotation_snaps)
		
	elif event is InputEventMouseMotion:
		var cam_angular_vel = event.relative * cam_speed
		pitch = clamp(pitch - cam_angular_vel.y, -TAU/4, TAU/4)
		yaw = yaw - cam_angular_vel.x

		$CameraArm.rotation.x = pitch
		$CameraArm.rotation.y = yaw
	elif event is InputEventKey:
		var evt = event as InputEventKey
		if evt.pressed && evt.scancode == KEY_F11:
			OS.window_fullscreen = !OS.window_fullscreen
		

onready var brick_ghost_template = preload("res://Aether/Construction/Brick_Ghost.tscn")
var brick_ghost: Brush
var spawn_rotation = 0.0


func set_build_mode(mode):

	if !brick_ghost:
		brick_ghost = brick_ghost_template.instance()
		get_tree().get_root().add_child(brick_ghost)
	brick_ghost.visible = (mode != Brush.BRUSH_OFF)
	brick_ghost.set_mode(mode)


onready var brick_template = preload("res://Aether/Construction/Brick.tscn")

func fire():
	if !brick_ghost || brick_ghost.current_mode == Brush.BRUSH_OFF:
		return
	
	if brick_ghost.current_mode == Brush.BRUSH_BUILD:
		var new_brick = brick_template.instance()
		new_brick.translation = brick_ghost.translation
		new_brick.rotation = brick_ghost.rotation
		new_brick.set_extents(brick_ghost.extents)
		get_tree().get_root().add_child(new_brick)
	elif brick_ghost.current_mode == Brush.BRUSH_DESTROY:
		var target = brick_ghost.target
		target.get_parent().remove_child(brick_ghost.target)
		brick_ghost.target = null
	elif brick_ghost.current_mode == Brush.BRUSH_EDIT:
		var target = brick_ghost.target as Brick
		target.set_extents(Vector3(1, 1, 1))
		
 

func jump():
	last_velocity.y = jump_speed
	print("jumping")

export var speed = 3.0
export var gravity = Vector3(0, -10, 0);
export var jump_speed = 6

var last_velocity = Vector3(0,0,0)

func _physics_process(delta):
	calc_movement(delta)
	do_raycast()
	
	
func calc_movement(delta):

	var horizontal = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var forward = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backwards")


	var input_movement = Vector2(horizontal, forward)
	var input_movement_length = input_movement.length()
	if input_movement_length > 1:
		input_movement /= input_movement_length

	var move_horizontal = $CameraArm.transform.basis.x * horizontal
	var move_forward = $CameraArm.transform.basis.x.cross(Vector3.UP)  * -forward

	var velocity_horizontal = (move_horizontal + move_forward) * speed

	var velocity_vertical = last_velocity.y + gravity.y * delta;

	var velocity_total = velocity_horizontal + Vector3(0, velocity_vertical, 0)

	last_velocity = move_and_slide(velocity_total)

var hit_result: Dictionary

signal test_hit(location, normal)

func do_raycast():
	
	var camera = $CameraArm/Camera
	var ray_coords = get_viewport().size * 0.5
	var from = camera.project_ray_origin(ray_coords)
	var direction = camera.project_ray_normal(ray_coords)
	var to = from + direction * 1000
	
	var space_state = get_world().direct_space_state
	hit_result = space_state.intersect_ray(from, to, [$CollisionShape])
	
	if hit_result && brick_ghost && brick_ghost.current_mode != Brush.BRUSH_OFF:
		var collider = hit_result.collider
		var brick = collider.owner as Brick
		# if colliding with an already existing brick
		if brick:
			
			
			if brick_ghost.current_mode == Brush.BRUSH_BUILD:
				brick_ghost.rotation = brick.rotation
				
				var spawn_direction = hit_result.normal
				emit_signal("test_hit", hit_result.position, hit_result.normal)
				
				var hit_position = hit_result.position
				var next_brick_direction = brick.get_suggested_build_direction(hit_position)
				var next_brick_position = brick.get_snapping_position(hit_position)
				brick_ghost.snap_to_position_and_direction(next_brick_position, next_brick_direction)

			elif brick_ghost.current_mode == Brush.BRUSH_DESTROY:
				brick_ghost.rotation = brick.rotation
				brick_ghost.translation = brick.translation
				brick_ghost.set_target(brick)
			elif brick_ghost.current_mode == Brush.BRUSH_EDIT:
				brick_ghost.rotation = brick.rotation
				brick_ghost.translation = brick.translation
				brick_ghost.set_target(brick)
		else:
			brick_ghost.rotation.y = spawn_rotation
			brick_ghost.translation = hit_result.position

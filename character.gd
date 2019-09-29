
extends KinematicBody


onready var brick_ghost_template = preload("res://Aether/Construction/Brush.tscn")
var brush: Brush

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
		get_brush().set_mode(Brush.BRUSH_OFF)
	elif event.is_action_pressed("slot_2"):
		get_brush().set_mode(Brush.BRUSH_BUILD)
	elif event.is_action_pressed("slot_3"):
		get_brush().set_mode(Brush.BRUSH_DESTROY)
	elif event.is_action_pressed("slot_4"):
		get_brush().set_mode(Brush.BRUSH_EDIT)

	elif event.is_action_pressed("variant_next"):
		get_brush().spawn_rotation += (TAU/rotation_snaps)
	elif event.is_action_pressed("variant_previous"):
		get_brush().spawn_rotation -= (TAU/rotation_snaps)

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

func get_brush():
	if !brush:
		brush = brick_ghost_template.instance()
		get_tree().get_root().add_child(brush)
	return brush

func fire():
	if brush:
		brush.fire()

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

func do_raycast():

	if brush:

		var camera = $CameraArm/Camera
		var ray_coords = get_viewport().size * 0.5
		var from = camera.project_ray_origin(ray_coords)
		var direction = camera.project_ray_normal(ray_coords)

		brush.aim_brush(from, direction)

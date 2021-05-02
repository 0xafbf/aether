extends Node

onready var imgui = $Control

var debugging: bool = false
onready var camera: Camera = $Camera

func _ready():
	yield(get_tree(), "idle_frame")
	camera.clear_current(false)
	
var look_direction: Vector2 = Vector2.ZERO

var key_w = 0
var key_a = 0
var key_s = 0
var key_d = 0

var panning = false

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_F12:
			toggle_debugging()
	elif event is InputEventMouseMotion:
		if panning:
			look_direction = event.relative
			get_tree().set_input_as_handled()	
	if debugging:
		if event is InputEventKey:
			var key: InputEventKey = event
			if key.scancode == KEY_W:
				key_w = 1 if key.pressed else 0
				get_tree().set_input_as_handled()
			if key.scancode == KEY_A:
				key_a = 1 if key.pressed else 0
				get_tree().set_input_as_handled()
			if key.scancode == KEY_S:
				key_s = 1 if key.pressed else 0
				get_tree().set_input_as_handled()
			if key.scancode == KEY_D:
				key_d = 1 if key.pressed else 0
				get_tree().set_input_as_handled()
		elif event is InputEventMouseButton:
			var evt_mouse: InputEventMouseButton = event
			if evt_mouse.button_index == 2:
				set_panning(evt_mouse.pressed)
				get_tree().set_input_as_handled()


func toggle_debugging():
	print("toggling debugger")
	if not debugging:
		debugging = true
		var current_cam = get_viewport().get_camera()
		if current_cam:
			camera.global_transform = current_cam.global_transform
		# camera.translation = current_cam.translation
		camera.make_current()
		camera.visible = true
		set_panning(false)
	else:
		debugging = false
		camera.clear_current()
		camera.visible = false

func set_panning(new_panning: bool):
	panning = new_panning
	if panning:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				
export var cam_speed = 3.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not debugging:
		return
	
	
	var horizontal = key_d - key_a
	var vertical = key_w - key_s
	
	if panning:
		var base_rot = camera.rotation
		base_rot.x += look_direction.y * -0.01
		base_rot.x = clamp(base_rot.x, -TAU*0.25, TAU*0.25)
		base_rot.y += look_direction.x * -0.01
		camera.rotation = base_rot
		look_direction = Vector2.ZERO
	
	var basis = camera.global_transform.basis
	
	
	
	
	camera.global_translate(horizontal * basis.x * delta * cam_speed)
	camera.global_translate(vertical * -basis.z * delta * cam_speed)
	
	imgui.begin()
	var pointed_object: Spatial = $Camera/RayCast.get_collider()
	if pointed_object:
		var s = pointed_object
		imgui.text("Object: %s" % s.name)
		var properties = s.get_property_list()
		var current_section = null
		var current_section_displayed = false
		for prop in properties:
			if prop.usage & PROPERTY_USAGE_NOEDITOR:
				continue
			elif prop.usage & PROPERTY_USAGE_CATEGORY:
				current_section = prop.name
				current_section_displayed = false
				
				continue
			elif (prop.usage & PROPERTY_USAGE_EDITOR
					or current_section == "Script Variables"):
				if not current_section_displayed:
					current_section_displayed = true
					imgui.text("===== %s =====" % current_section)
				var value = str(s[prop.name])
				imgui.text("%s: %s" % [prop.name, value])
#			else:
#				imgui.text("PROP: %s" % prop.name)
#				for bit in range(13):
#					if prop.usage & 1<<bit:
#						imgui.text("FLAG: %d" % (1<<bit))
					
	
	
	
	
	
